defmodule ExGraphQL.Test.Issue do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:title, :string)
  gql_field(:description, :string)
  gql_field(:assignee, ExGraphQL.Test.User)
end
