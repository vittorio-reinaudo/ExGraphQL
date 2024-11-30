defmodule ExGraphQL.Test.User do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:email, :string)
  gql_field(:team, ExGraphQL.Test.Team)
end
