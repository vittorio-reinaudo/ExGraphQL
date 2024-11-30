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
```

## Declare a nested object
```elixir
defmodule MyApp.GQLObject.Team do
  use ExGraphQL.Object

  gql_field(:id, :integer)
  gql_field(:name, :string)
  gql_field(:organization, MyApp.GQLObject.Organization)
end
```
