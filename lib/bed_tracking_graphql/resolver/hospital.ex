defmodule BedTrackingGraphql.Resolver.Hospital do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get_hospitals(_params, info) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospitals} <- Context.Hospital.list() do
      {:ok, %{hospitals: hospitals}}
    end
  end

  def get_hospital(%{input: %{hospital_id: hospital_id}}, _info) do
    with {:ok, hospital} <- Context.Hospital.get(hospital_id) do
      {:ok, %{hospital: hospital}}
    end
  end

  def create_hospital(%{input: %{name: _, latitude: _, longitude: _, address: _} = params}, info) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospital} <- Context.Hospital.create(params) do
      {:ok, %{hospital: hospital}}
    end
  end
end
