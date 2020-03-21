defmodule BedTrackingGraphql.Resolver.Bed do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get(%{input: %{id: id}}, _info) do
    with {:ok, bed} <- Context.Bed.get(id) do
      {:ok, %{bed: bed}}
    end
  end

  def register(%{input: %{hospital_id: hospital_id}}, _info) do
    with {:ok, bed} <- Context.Bed.register(hospital_id) do
      {:ok, %{bed: bed}}
    end
  end

  def update_availability(%{input: %{id: id, available: available}}, _info) do
    with {:ok, bed} <- Context.Bed.update_availability(id, available) do
      {:ok, %{bed: bed}}
    end
  end
end
