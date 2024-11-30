defmodule ExGraphQL.Test.Organization do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:country, :string)
end
