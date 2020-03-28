defmodule BedTracking.Context.Authentication do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Admin

  def current_admin(%{context: %{current_admin: current_admin}}) do
    {:ok, current_admin}
  end

  def current_admin(_info), do: {:error, %Error.AuthenticationError{}}

  def current_hospital(%{context: %{current_hospital: current_hospital}}) do
    {:ok, current_hospital}
  end

  def current_hospital(_info), do: {:error, %Error.AuthenticationError{}}

  def parse_token(token) do
    with {:ok, admin_id} <- verify_token(token),
         {:ok, admin} <- get_admin(admin_id) do
      {:ok, admin}
    end
  end

  def create_token(admin_id) do
    secret = Application.get_env(:bed_tracking, :token_secret)
    salt = Application.get_env(:bed_tracking, :token_salt)

    with {:ok, admin} <- get_admin(admin_id),
         token <- Phoenix.Token.sign(secret, salt, admin.id) do
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

  defp get_admin(admin_id) do
    Admin
    |> Context.Admin.Query.where_id(admin_id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.NotFoundError{fields: %{id: admin_id}, type: "Admin"}}

      admin ->
        {:ok, admin}
    end
  end
end
