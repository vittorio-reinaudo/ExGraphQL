defmodule ExGraphQL.Client do
  use Tesla

  plug(Tesla.Middleware.BaseUrl)
  plug(Tesla.Middleware.Headers, [{"Content-Type", "application/json"}])
  plug(Tesla.Middleware.JSON)

  def execute(url, token, query) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, url},
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{token}"}]}
    ])
    |> Tesla.post("/", %{query: query})
  end
end
