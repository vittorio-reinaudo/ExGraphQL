# ExGraphQL

### Overview
ExGraphQL is a light library to perform query to GraphQL API via Elixir redefining the target object schema and making query more readable

### ExGraphQL feature

Object: provide a simple way to define object and their parameter with type and nested object
QueryBuilder: provide a smart way to apply filter to your query and define the schema of return
Client: provide a client for graphQL to simply set config information and call API

# Installation

To install ExGraphQL, just add an entry to your `mix.exs`:

```elixir
def deps do
  [
    # ...
    {:ex_graphql, "~> 0.1"}
  ]
end
```

(Check [Hex](https://hex.pm/packages/ex_graphql) to make sure you're using an up-to-date version number.)

## Configure first object

```elixir
defmodule MyApp.GQLObject.Organization do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:country, :string)
end

defmodule MyApp.GQLObject.Member do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
end
```

## Declare a nested object

If the object nested are in relation 1:N use `opts` to declare `multiple_link: true`
```elixir
defmodule MyApp.GQLObject.Team do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:organization, MyApp.GQLObject.Organization)
  gql_field(:member, MyApp.GQLObject.Member, multiple_link: true)
end
```

## Make your first query

```elixir
defmodule MyApp.GraphAPI do
  base_url = "https://api.graph-provider/graphql"
  token = System.get_env("graph_api_token", "")
  query = ExGraphQL.QueryBuilder.build_query(MyApp.Object.Team)
  ExGraphQL.Client.execute(base_url, token, query)
end
```

## Add filter to your query

```elixir
defmodule MyApp.GraphAPI do
  base_url = "https://api.graph-provider/graphql"
  token = System.get_env("graph_api_token", "")
  query = ExGraphQL.QueryBuilder.build_query(MyApp.Object.Team, 
    filters: [
      name: [eq: "my-team"],
        organization: [
          country: [contains: "ita"]
      ]
    ]
  )
  ExGraphQL.Client.execute(base_url, token, query)
end
```

## Contribute

To contribute to the repository, please submit a pull request to the [ExGraphQL](https://github.com/vittorio-reinaudo/ex-graphql) project on GitHub.

