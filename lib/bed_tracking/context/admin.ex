defmodule BedTracking.Context.Admin do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Admin

  def login(email, password) do
    with email <- String.downcase(email),
         {:ok, admin} <- fetch_admin_by_email(email),
         {:ok, :verified} <- verify_password(admin, password),
         {:ok, token} <- Context.Authentication.create_token(admin.id) do
      {:ok, token}
    end
  end

  defp fetch_admin_by_email(email) do
    Admin
    |> Context.Admin.Query.where_email(email)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.AuthenticationError{}}

      admin ->
        {:ok, admin}
    end
  end

  defp verify_password(admin, password) do
    if Bcrypt.verify_pass(password, admin.password_hash) do
      {:ok, :verified}
    else
      {:error, %Error.AuthenticationError{}}
    end
  end
end
