defmodule ExGraphQL.Object do
  @moduledoc """
  Defines a behaviour and macros for creating GraphQL objects
  """

  @callback __graphql_fields__() :: list()

  defmacro gql_field(name, type, opts \\ []) do
    quote do
      IO.inspect(unquote(__MODULE__), label: "Current module")
      IO.inspect({:adding_field, unquote(name), unquote(type), unquote(opts)})
      Module.put_attribute(unquote(__CALLER__.module), :graphql_fields, {unquote(name), unquote(type), unquote(opts)})
#      @graphql_fields {unquote(name), unquote(type), unquote(opts)}
    end
  end

  defmacro __using__(_opts) do
    IO.puts("Using ExGraphQL.Object in #{__MODULE__}")
    IO.inspect("ExGraphQL.Object is being used in #{__CALLER__.module}")

    quote do
      @before_compile unquote(__MODULE__)
      import unquote(__MODULE__), only: [gql_field: 2, gql_field: 3]

      Module.register_attribute(unquote(__CALLER__.module), :graphql_fields, accumulate: true, persist: true)

      @doc "Retrieve all defined GraphQL fields"
      def __graphql_fields__ do
        unquote(__CALLER__.module).__info__(:attributes)
        |> Enum.filter(fn {k, _v} -> k == :graphql_fields end)
        |> Enum.reduce([], fn {_k, [v]}, acc -> [v | acc] end)
        |> Enum.reverse()
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def graphql_type do
        __MODULE__
      end
    end
  end
end
