defmodule BedTracking.Context.HospitalManager do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.HospitalManager

  def create(params) do
    with {:ok, hospital_manager} <- create_hospital_manager(params) do
      {:ok, hospital_manager}
    end
  end

  def login(email, password) do
    with email <- String.downcase(email),
         {:ok, hospital_manager} <- fetch_by_email(email),
         {:ok, :verified} <- verify_password(hospital_manager, password) do
      {:ok, hospital_manager}
    end
  end

  defp create_hospital_manager(params) do
    %HospitalManager{}
    |> HospitalManager.create_changeset(params)
    |> Repo.insert()
  end

  defp fetch_by_email(email) do
    HospitalManager
    |> Context.HospitalManager.Query.where_email(email)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.AuthenticationError{}}

      hospital_manager ->
        {:ok, hospital_manager}
    end
  end

  defp verify_password(hospital_manager, password) do
    if Bcrypt.verify_pass(password, hospital_manager.password_hash) do
      {:ok, :verified}
    else
      {:error, %Error.AuthenticationError{}}
    end
  end
end
