defmodule BedTracking.Context.Authentication do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.HospitalManager

  def current_hospital_manager(%{context: %{current_hospital_manager: current_hospital_manager}}) do
    {:ok, current_hospital_manager}
  end

  def current_hospital_manager(_info), do: {:error, %Error.AuthenticationError{}}

  def parse_token(token) do
    with {:ok, hospital_manager_id} <- verify_token(token),
         {:ok, hospital_manager} <- get_hospital_manager(hospital_manager_id) do
      {:ok, hospital_manager}
    end
  end

  def create_token(hospital_manager_id) do
    secret = Application.get_env(:bed_tracking, :token_secret)
    salt = Application.get_env(:bed_tracking, :token_salt)

    with {:ok, hospital_manager} <- get_hospital_manager(hospital_manager_id),
         token <- Phoenix.Token.sign(secret, salt, hospital_manager.id) do
      {:ok, token}
    end
  end

  defp verify_token(token) do
    secret = Application.get_env(:bed_tracking, :token_secret)
    salt = Application.get_env(:bed_tracking, :token_salt)
    max_age = Application.get_env(:bed_tracking, :token_max_age)

    case Phoenix.Token.verify(secret, salt, token, max_age: max_age) do
      {:ok, admin_id} -> {:ok, admin_id}
      {:error, :expired} -> {:error, %Error.ExpiredTokenError{token: token}}
      {:error, :invalid} -> {:error, %Error.InvalidTokenError{token: token}}
    end
  end

  defp get_hospital_manager(hospital_manager_id) do
    HospitalManager
    |> Context.HospitalManager.Query.where_id(hospital_manager_id)
    |> Context.HospitalManager.Query.where_not_deleted()
    |> Context.HospitalManager.Query.with_hospital()
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.NotFoundError{fields: %{id: hospital_manager_id}, type: "HospitalManager"}}

      hospital_manager ->
        {:ok, hospital_manager}
    end
  end
end
