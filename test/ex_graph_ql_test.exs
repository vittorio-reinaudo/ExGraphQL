defmodule ExGraphQL.NestedQueryBuilderTest do
  use ExUnit.Case
  doctest ExGraphQL.QueryBuilder

  alias ExGraphQL.QueryBuilder

  test "build query with multiple levels of nesting" do
    query = QueryBuilder.build_query(Issue)

    expected_query =
      """
      query {
        issue(first: 10) {
          nodes {
            id title description assignee {
              id name email team {
                nodes {
                  id name organization {
                    id name country
                  }
                }
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
      """
      |> String.trim()

    assert String.replace(query, ~r/\s+/, "")  == String.replace(expected_query, ~r/\s+/, "")
  end

  test "build query with deep nested filters" do
    query =
      QueryBuilder.build_query(
        Issue,
        filters: [
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
        ],
        limit: 100,
        order_by: "createdAt"
      )

    expected_query =
      """
      query {
        issue(
          filter : { title: { contains: "Bug"}, assignee: { name: { startsWith: "John"}, team: { name: { eq: "Engineering"}, organization: { country: { eq: "USA"} } } } }
          first: 100
          orderBy: createdAt
        ) {
          nodes {
            id title description assignee {
              id name email team {
                nodes {
                  id name organization {
                    id name country
                  }
                }
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
      """
      |> String.trim()

    assert String.replace(query, ~r/\s+/, "")  == String.replace(expected_query, ~r/\s+/, "")
  end

end
defmodule Issue do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:title, :string)
  gql_field(:description, :string)
  gql_field(:assignee, User)
end

defmodule User do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:email, :string)
  gql_field(:team, Team, [multiple_link: true])
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

