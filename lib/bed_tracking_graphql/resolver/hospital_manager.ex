defmodule BedTrackingGraphql.Resolver.HospitalManager do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Error

  def get_current(_params, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info) do
      {:ok, %{hospital_manager: current_hospital_manager}}
    end
  end

  def create(%{input: %{username: _, password: _} = params}, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, true} <- is_admin(current_hospital_manager),
         {:ok, params} <- build_params(params, current_hospital_manager),
         {:ok, hospital_manager} <- Context.HospitalManager.create(params) do
      {:ok, %{hospital_manager: hospital_manager}}
    end
  end

  def update(%{input: %{id: id} = params}, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, true} <- is_admin(current_hospital_manager),
         {:ok, hospital_manager} <- Context.HospitalManager.update(id, params) do
      {:ok, %{hospital_manager: hospital_manager}}
    end
  end

  def delete(%{input: %{id: id}}, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, true} <- is_admin(current_hospital_manager),
         {:ok, success} <- Context.HospitalManager.delete(id, current_hospital_manager) do
      {:ok, %{success: success}}
    end
  end

  def login(%{input: %{username: username, password: password}}, _info) do
    with {:ok, %{token: token, is_changed_password: is_changed_password}} <- Context.HospitalManager.login(username, password) do
      {:ok, %{token: token, is_changed_password: is_changed_password}}
    end
  end

  def change_password(%{input: %{old_password: old_password, new_password: new_password}}, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, token} <- Context.HospitalManager.change_password(old_password, new_password, current_hospital_manager) do
      {:ok, %{token: token}}
    end
  end

  def reset_password(%{input: %{hospital_manager_id: hospital_manager_id, new_password: new_password}}, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, true} <- is_admin(current_hospital_manager),
         {:ok, success} <- Context.HospitalManager.reset_password(hospital_manager_id, new_password) do
      {:ok, %{success: success}}
    end
  end

  defp is_admin(current_hospital_manager) do
    if current_hospital_manager.is_admin == true do
      {:ok, true}
    else
      {:error, %Error.AuthenticationError{}}
    end
  end

  defp build_params(params, current_hospital_manager) do
    params = Map.merge(params, %{hospital_id: current_hospital_manager.hospital_id})
    {:ok, params}
  end
end
