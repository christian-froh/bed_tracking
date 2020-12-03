defmodule BedTrackingGraphql.Resolver.HospitalManager do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get_current(_params, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info) do
      {:ok, %{hospital_manager: current_hospital_manager}}
    end
  end

  def create(
        %{input: %{username: _, password: _, firstname: _, lastname: _, hospital_id: _} = params},
        info
      ) do
    with {:ok, _current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, hospital_manager} <- Context.HospitalManager.create(params) do
      {:ok, %{hospital_manager: hospital_manager}}
    end
  end

  def update(%{input: %{id: id} = params}, info) do
    with {:ok, _current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, hospital_manager} <- Context.HospitalManager.update(id, params) do
      {:ok, %{hospital_manager: hospital_manager}}
    end
  end

  def login(%{input: %{username: username, password: password}}, _info) do
    with {:ok, token} <- Context.HospitalManager.login(username, password) do
      {:ok, %{token: token}}
    end
  end

  def change_password(%{input: %{old_password: old_password, new_password: new_password}}, info) do
    with {:ok, current_hospital_manager} <- Context.Authentication.current_hospital_manager(info),
         {:ok, token} <- Context.HospitalManager.change_password(old_password, new_password, current_hospital_manager) do
      {:ok, %{token: token}}
    end
  end
end
