defmodule ExGraphQL.Client do
  use Tesla

  plug(Tesla.Middleware.BaseUrl)
  plug(Tesla.Middleware.Headers, [{"Content-Type", "application/json"}])
  plug(Tesla.Middleware.JSON)

  @doc"""
    Use execute to post the query
    function will manage returning status
    """
  def execute(url, token, query) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, url},
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{token}"}]}
    ])
    |> Tesla.post("/", %{query: query})
  end
end
