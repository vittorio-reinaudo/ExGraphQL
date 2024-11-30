defmodule ExGraphQL.Test.Team do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:organization, ExGraphQL.Test.Organization)
end
