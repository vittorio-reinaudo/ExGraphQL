defmodule ExGraphQL do
  alias ExGraphQL.{Object, QueryBuilder, Client}

  defmacro __using__(_) do
    quote do
      use ExGraphQL.Object
    end
  end

  def query(module, filters \\ []) do
    object_name =
      module
      |> to_string()
      |> String.split(".")
      |> List.last()
      |> Macro.underscore()

    fields = module.fields() |> Enum.map(fn {name, _type} -> name end)
    QueryBuilder.build_query(object_name, fields, filters)
  end

  def execute(url, token, module, filters \\ []) do
    query = query(module, filters)
    Client.execute(url, token, query)
  end
end
