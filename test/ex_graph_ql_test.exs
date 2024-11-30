defmodule ExGraphQL.NestedQueryBuilderTest do
  use ExUnit.Case
  doctest ExGraphQL.QueryBuilder

  alias ExGraphQL.QueryBuilder

  test "build query with multiple levels of nesting" do
    query = QueryBuilder.build_query(Issue)

    expected_query =
      """
      query {
        issue {
          id title description assignee {
            id name email team {
              id name organization {
                id name country
              }
            }
          }
        }
      }
      """
      |> String.trim()

    assert String.replace(query, ~r/\s+/, "")  == String.replace(expected_query, ~r/\s+/, "")
  end

  test "build query with deep nested filters" do
    query =
      QueryBuilder.build_query(Issue,
        title: [contains: "Bug"],
        assignee: [
          name: [starts_with: "John"],
          team: [
            name: [eq: "Engineering"],
            organization: [
              country: [eq: "USA"]
            ]
          ]
        ]
      )

    expected_query =
      """
      query {
        issue(title: { contains: "Bug"}, assignee: { name: { startsWith: "John"}, team: { name: { eq: "Engineering"}, organization: { country: { eq: "USA"} } } }) {
          id title description assignee {
            id name email team {
              id name organization {
                id name country
              }
            }
          }
        }
      }
      """
      |> String.trim()

    assert String.replace(query, ~r/\s+/, "")  == String.replace(expected_query, ~r/\s+/, "")
  end

end

defmodule User do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:email, :string)
  gql_field(:team, Team)
end

defmodule Team do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:organization, Organization)
end

defmodule Organization do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:country, :string)
end

defmodule Issue do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:title, :string)
  gql_field(:description, :string)
  gql_field(:assignee, User)
end

