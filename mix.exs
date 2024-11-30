defmodule ExGraphQL.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_graphql,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:tesla, "~> 1.4"},
      {:jason, "~> 1.3"}
    ]
  end
end
