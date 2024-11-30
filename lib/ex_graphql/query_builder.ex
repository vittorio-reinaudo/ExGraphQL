defmodule ExGraphQL.QueryBuilder do
  @moduledoc """
  Advanced GraphQL query builder supporting infinite levels of nested objects
  """

  def build_query(object_module, filters \\ [], operation_type \\ :query) do
    query_name = object_module |> Module.split() |> List.last() |> Macro.underscore()

    field_strings = process_fields(object_module)
    filter_string = build_filter_string(filters) |> add_filter_bracket()

    operation =
      case operation_type do
        :query -> "query"
        :mutation -> "mutation"
        _ -> "query"
      end

    """
    #{operation} {
      #{query_name}#{filter_string} {
        #{field_strings}
      }
    }
    """
    |> String.trim()
  end

  @doc """
  Recursively process fields, supporting infinite levels of nesting
  """
  def process_fields(object_module, depth \\ 0, max_depth \\ 5) do
    # Prevent infinite recursion
    if depth >= max_depth do
      ""
    else
      object_module.__graphql_fields__()
      |> Enum.map(fn {name, type, _opts} ->
        process_single_field(name, type, depth, max_depth)
      end)
      |> Enum.join(" ")
    end
  end

  # Process a single field, handling nested objects
  defp process_single_field(name, type, depth, max_depth) do
    cond do
      # Check if it's a nested object type
      is_atom(type) and
        Code.ensure_loaded?(type) and
          function_exported?(type, :__graphql_fields__, 0) ->
        # Recursively process nested object
        nested_fields = process_fields(type, depth + 1, max_depth)
        "#{name} { #{nested_fields} }"

      # Regular scalar field
      true ->
        to_string(name)
    end
  end

  @doc """
  Build filter string with support for deep nesting
  """
  def build_filter_string(filters, depth \\ 0, max_depth \\ 5) do
    # Prevent excessive nesting
    if depth >= max_depth do
      ""
    else
      filters
      |> Enum.map(fn
        {field, conditions} when is_list(conditions) ->
          build_single_filter(field, conditions, depth, max_depth)
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.join(", ")
    end
  end

  # Build filter for a single field, handling nested conditions
  defp build_single_filter(field, conditions, depth, max_depth) do
    cond do
      # Nested object filter
      Keyword.keyword?(conditions) and
          Enum.any?(conditions, fn {_, val} -> is_list(val) end) ->
        nested_filters =
          Enum.map(conditions, fn {nested_field, nested_conditions} ->
            nested_filter_string =
              build_filter_string(
                [{nested_field, nested_conditions}],
                depth + 1,
                max_depth
              )

            nested_filter_string
          end)
          |> Enum.reject(&(&1 == ""))
          |> Enum.join(", ")

        "#{field}: { #{nested_filters} }"

      Keyword.keyword?(conditions) ->
        filter_conditions =
          conditions
          |> Enum.map(fn {filter_type, value} ->
            format_filter(to_string(field), value, filter_type)
          end)
          |> Enum.reject(&is_nil/1)
          |> Enum.join(", ")

        filter_conditions

      # Fallback
      true ->
        nil
    end
  end

  defp format_filter(field, value, :eq), do: "#{field}: { eq: #{format_value(value)}}"
  defp format_filter(field, value, :contains), do: "#{field}: { contains: #{format_value(value)}}"
  defp format_filter(field, value, :starts_with), do: "#{field}: { startsWith: #{format_value(value)}}"

  defp format_value(value) when is_binary(value), do: "\"#{value}\""
  defp format_value(value) when is_integer(value), do: "#{value}"
  defp format_value(value) when is_boolean(value), do: "#{value}"
  defp format_value(_), do: nil

  defp add_filter_bracket(""), do: ""
  defp add_filter_bracket(filters), do: "( #{filters} )"

  @doc """
  Build variables for deeply nested queries
  """
  def build_variables(filters) do
    flatten_variables(filters)
    |> Enum.into(%{})
  end

  # Recursively flatten nested variables
  defp flatten_variables(filters, prefix \\ "") do
    Enum.flat_map(filters, fn
      {field, conditions} when is_list(conditions) ->
        if Keyword.keyword?(conditions) do
          # Handle nested conditions
          nested_vars =
            Enum.flat_map(conditions, fn
              {nested_field, nested_conditions} when is_list(nested_conditions) ->
                new_prefix = if prefix == "", do: "#{field}", else: "#{prefix}_#{field}"
                flatten_variables([{nested_field, nested_conditions}], new_prefix)

              {_, _} ->
                []
            end)

          # Handle direct filter conditions
          direct_vars =
            Enum.filter_map(
              conditions,
              fn {k, _} -> not is_list(Keyword.get(conditions, k, [])) end,
              fn {k, v} ->
                key = if prefix == "", do: "#{field}_#{k}", else: "#{prefix}_#{field}_#{k}"
                {key, v}
              end
            )

          nested_vars ++ direct_vars
        else
          # Regular filter conditions
          [{field, conditions}]
        end
    end)
  end
end