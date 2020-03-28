defmodule BedTrackingWeb.Plugs.Context do
  import Plug.Conn
  alias BedTracking.Context

  def call(conn) do
    context = build_context(conn)
    context
  end

  defp build_context(conn) do
    %{}
    |> build_authorization(conn)
  end

  defp build_authorization(context, conn) do
    with ["Bearer " <> auth_token | _] <- get_req_header(conn, "authorization"),
         {:ok, current_admin} <- Context.Authentication.parse_token(auth_token) do
      Map.merge(context, %{current_admin: current_admin})
    else
      _ -> context
    end
  end
end
