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

  def update(id, params) do
    with {:ok, hospital_manager} <- get_hospital_manager(id),
         {:ok, hospital_manager} <- update_hospital_manager(hospital_manager, params) do
      {:ok, hospital_manager}
    end
  end

  def delete(id, current_hospital_manager) do
    with {:ok, hospital_manager} <- get_hospital_manager(id),
         {:ok, true} <- can_delete?(hospital_manager, current_hospital_manager),
         {:ok, _} <- delete_hospital_manager(hospital_manager) do
      {:ok, true}
    end
  end

  def login(username, password) do
    with username <- String.downcase(username),
         {:ok, hospital_manager} <- fetch_by_username(username),
         {:ok, :verified} <- verify_password(hospital_manager, password),
         {:ok, _updated_hospital_manager} <- update_last_login(hospital_manager),
         {:ok, token} <- Context.Authentication.create_token(hospital_manager.id) do
      {:ok, %{token: token, is_changed_password: hospital_manager.is_changed_password}}
    end
  end

  def change_password(old_password, new_password, hospital_manager) do
    with {:ok, :verified} <- verify_old_password(old_password, hospital_manager),
         {:ok, hospital_manager} <- do_change_password(new_password, hospital_manager),
         {:ok, token} <- Context.Authentication.create_token(hospital_manager.id) do
      {:ok, token}
    end
  end

  def reset_password(hospital_manager_id, new_password) do
    with {:ok, hospital_manager} <- get_hospital_manager(hospital_manager_id),
         {:ok, _hospital_manager} <- do_reset_password(new_password, hospital_manager) do
      {:ok, true}
    end
  end

  defp create_hospital_manager(params) do
    %HospitalManager{}
    |> HospitalManager.create_changeset(params)
    |> Repo.insert()
    |> case do
      {:error, %Ecto.Changeset{errors: [username: {_, [constraint: :unique, constraint_name: "hospital_managers_username_index"]}]}} ->
        {:error, %Error.UsernameAlreadyInUseError{}}

      other ->
        other
    end
  end

  defp update_hospital_manager(hospital_manager, params) do
    hospital_manager
    |> HospitalManager.update_changeset(params)
    |> Repo.update()
  end

  defp fetch_by_username(username) do
    HospitalManager
    |> Context.HospitalManager.Query.where_username(username)
    |> Context.HospitalManager.Query.where_not_deleted()
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

  defp update_last_login(hospital_manager) do
    params = %{last_login_at: DateTime.utc_now()}

    hospital_manager
    |> HospitalManager.update_changeset(params)
    |> Repo.update()
  end

  defp delete_hospital_manager(hospital_manager) do
    params = %{deleted_at: DateTime.utc_now()}

    hospital_manager
    |> HospitalManager.delete_changeset(params)
    |> Repo.update()
  end

  defp get_hospital_manager(id) do
    HospitalManager
    |> Context.HospitalManager.Query.where_id(id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.NotFoundError{fields: %{id: id}, type: "HospitalManager"}}

      hospital_manager ->
        {:ok, hospital_manager}
    end
  end

  defp verify_old_password(old_password, hospital_manager) do
    if Bcrypt.verify_pass(old_password, hospital_manager.password_hash) do
      {:ok, :verified}
    else
      {:error, %Error.WrongPasswordError{}}
    end
  end

  defp do_change_password(new_password, hospital_manager) do
    params = %{password: new_password}

    hospital_manager
    |> HospitalManager.change_password_changeset(params)
    |> Repo.update()
  end

  defp do_reset_password(new_password, hospital_manager) do
    params = %{password: new_password}

    hospital_manager
    |> HospitalManager.reset_password_changeset(params)
    |> Repo.update()
  end

  defp can_delete?(hospital_manager, current_hospital_manager) do
    if current_hospital_manager.hospital_id == hospital_manager.hospital_id do
      {:ok, true}
    else
      {:error, "not belong to hospital"}
    end
  end
end
