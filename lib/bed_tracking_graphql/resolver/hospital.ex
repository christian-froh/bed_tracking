defmodule BedTrackingGraphql.Resolver.Hospital do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get_hospitals(_params, info) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospitals} <- Context.Hospital.list() do
      {:ok, %{hospitals: hospitals}}
    end
  end

  def get_hospital(_params, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, hospital} <- Context.Hospital.get(current_hospital.id) do
      {:ok, %{hospital: hospital}}
    end
  end

  def create_hospital(%{input: %{name: _, latitude: _, longitude: _, address: _} = params}, info) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospital} <- Context.Hospital.create(params) do
      {:ok, %{hospital: hospital}}
    end
  end

  def use_qr_code_system(%{input: %{use_qr_code: use_qr_code}}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, hospital} <- Context.Hospital.use_qr_code_system(use_qr_code, current_hospital.id) do
      {:ok, %{hospital: hospital}}
    end
  end
end
