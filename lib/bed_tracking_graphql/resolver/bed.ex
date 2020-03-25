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

  def activate(%{input: %{id: id, reference: reference}}, _info) do
    with {:ok, bed} <- Context.Bed.activate(id, reference) do
      {:ok, %{bed: bed}}
    end
  end

  def deactivate(%{input: %{id: id}}, _info) do
    with {:ok, bed} <- Context.Bed.deactivate(id) do
      {:ok, %{bed: bed}}
    end
  end

  def update_availability(%{input: %{id: id, available: available}}, _info) do
    with {:ok, bed} <- Context.Bed.update_availability(id, available) do
      {:ok, %{bed: bed}}
    end
  end

  def update_number_of_beds(
        %{input: %{hospital_id: hospital_id, number_of_beds: number_of_beds}},
        _info
      ) do
    with {:ok, success} <- Context.Bed.update_number_of_beds(hospital_id, number_of_beds) do
      {:ok, %{success: success}}
    end
  end

  def update_number_of_available_beds(
        %{input: %{hospital_id: hospital_id, number_of_available_beds: number_of_available_beds}},
        _info
      ) do
    with {:ok, success} <-
           Context.Bed.update_number_of_available_beds(hospital_id, number_of_available_beds) do
      {:ok, %{success: success}}
    end
  end
end
