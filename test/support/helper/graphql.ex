defmodule BedTrackingWeb.Helper.Graphql do
  @moduledoc """
  this module provides graphql helper functions which are used in tests
  """
  use Plug.Test

  def graphql_public_query(options) do
    locale = options[:locale] || "en"

    conn(:post, "/api", build_query(options[:query], options[:variables]))
    |> put_req_header("content-type", "application/json")
    |> put_req_header("accept-language", locale)
  end

  def graphql_query(options) do
    auth_token = options[:token]
    locale = options[:locale] || "en"

    conn(:post, "/api", build_query(options[:query], options[:variables]))
    |> put_req_header("content-type", "application/json")
    |> put_req_header("authorization", "Bearer #{auth_token}")
    |> put_req_header("accept-language", locale)
  end

  defp build_query(query, variables) do
    %{
      "query" => query,
      "variables" => variables
    }
    |> Jason.encode!()
  end
end
