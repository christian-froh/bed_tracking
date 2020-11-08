defmodule BedTrackingWeb.Helper.Graphql do
  @moduledoc """
  this module provides graphql helper functions which are used in tests
  """
  use Plug.Test

  def graphql_public_query(options) do
    conn(:post, "/api", build_query(options[:query], options[:variables]))
    |> put_req_header("content-type", "application/json")
  end

  def graphql_query(options) do
    token = options[:token]

    conn(:post, "/api", build_query(options[:query], options[:variables]))
    |> put_req_header("content-type", "application/json")
    |> put_req_header("hospitalid", token)
  end

  defp build_query(query, variables) do
    %{
      "query" => query,
      "variables" => variables
    }
    |> Jason.encode!()
  end
end
