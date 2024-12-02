defmodule ExGraphQL.Client do

  @doc"""
    Use execute to post the query
    function will manage returning status
    """
  def execute(url, token, query) do
    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{token}"}
    ]

    IO.inspect url, label: "Connecting to"
    IO.inspect query, label: "Executing query"

    case HTTPoison.post(url, Jason.encode!(%{query: query}), headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)["data"]}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
