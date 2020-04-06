defmodule BedTrackingGraphql.Resolver.Bed do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.get(id) do
      {:ok, %{bed: bed}}
    end
  end

  def register_multiple(%{input: %{ward_id: ward_id, number_of_beds: number_of_beds}}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, beds} <-
           Context.Bed.register_multiple(number_of_beds, ward_id, current_hospital.id) do
      {:ok, %{beds: beds}}
    end
  end

  def register(%{input: %{ward_id: ward_id}}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.register(ward_id, current_hospital.id) do
      {:ok, %{bed: bed}}
    end
  end

  def remove(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, success} <- Context.Bed.remove(id) do
      {:ok, %{success: success}}
    end
  end

  def update(%{input: %{id: id} = params}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.update(id, params) do
      {:ok, %{bed: bed}}
    end
  end
end
