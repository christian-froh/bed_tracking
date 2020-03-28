defmodule BedTrackingWeb.Plugs.Context do
  import Plug.Conn
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Hospital

  def call(conn) do
    context = build_context(conn)
    context
  end

  defp build_context(conn) do
    %{}
    |> build_authorization(conn)
    |> build_hospital_authorization(conn)
  end

  defp build_authorization(context, conn) do
    with ["Bearer " <> auth_token | _] <- get_req_header(conn, "authorization"),
         {:ok, current_admin} <- Context.Authentication.parse_token(auth_token) do
      Map.merge(context, %{current_admin: current_admin})
    else
      _ -> context
    end
  end

  defp build_hospital_authorization(context, conn) do
    with [hospital_id | _] <- get_req_header(conn, "hospital-id"),
         {:ok, current_hospital} <- get_hospital(hospital_id) do
      Map.merge(context, %{current_hospital: current_hospital})
    else
      _ -> context
    end
  end

  defp get_hospital(hospital_id) do
    Hospital
    |> Context.Hospital.Query.where_id(hospital_id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.AuthenticationError{}}

      hospital ->
        {:ok, hospital}
    end
  end
end
