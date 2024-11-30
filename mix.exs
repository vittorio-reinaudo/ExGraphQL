defmodule ExGraphQL.MixProject do
  use Mix.Project

  @source_url "https://github.com/vittorio-reinaudo/ex-graphql"

  def project do
    [
      app: :ex_graphql,
      version: "0.1.1",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: [
        main: "overview",
        extra_section: "GUIDES",
        formatters: ["html", "epub"],
        groups_for_modules: groups_for_modules(),
        extras: extras()
      ],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:httpoison, "~> 2.2"},
      {:jason, "~> 1.3"}
    ]
  end

  defp package do
    [
      description: "GraphQL API Builder for Elixir",
      maintainers: [
        "Vittorio Reinaudo"
      ],
      licenses: ["MIT"],
      links: %{
        GitHub: @source_url
      }
    ]
  end

  defp groups_for_modules do
    [
      "Base Concept": [
        ExGraphQL.Object,
        ExGraphQL.QueryBuilder,
        ExGraphQL.Client,
      ],
    ]
  end

  defp extras do
    [
      "guides/overview.md",
      "guides/installation.md"
    ]
  end
end
