defmodule BedTrackingGraphql.Resolver.HospitalManager do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def create(
        %{input: %{email: _, password: _, firstname: _, lastname: _, hospital_id: _} = params},
        info
      ) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospital_manager} <- Context.HospitalManager.create(params) do
      {:ok, %{hospital_manager: hospital_manager}}
    end
  end

  def update(%{input: %{id: id} = params}, info) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospital_manager} <- Context.HospitalManager.update(id, params) do
      {:ok, %{hospital_manager: hospital_manager}}
    end
  end

  def login(%{input: %{email: email, password: password}}, _info) do
    with {:ok, hospital_manager} <- Context.HospitalManager.login(email, password) do
      {:ok, %{hospital_manager: hospital_manager}}
    end
  end
end
