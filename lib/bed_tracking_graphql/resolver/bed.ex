defmodule BedTrackingGraphql.Resolver.Bed do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.get(id) do
      {:ok, %{bed: bed}}
    end
  end

  def register_multiple(%{input: %{number_of_beds: number_of_beds}}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, beds} <- Context.Bed.register_multiple(number_of_beds, current_hospital.id) do
      {:ok, %{beds: beds}}
    end
  end

  def register(_params, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.register(current_hospital.id) do
      {:ok, %{bed: bed}}
    end
  end

  def activate(%{input: %{id: id, reference: reference}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.activate(id, reference) do
      {:ok, %{bed: bed}}
    end
  end

  def deactivate(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.deactivate(id) do
      {:ok, %{bed: bed}}
    end
  end

  def update_availability(%{input: %{id: id, available: available}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.update_availability(id, available) do
      {:ok, %{bed: bed}}
    end
  end

  def update_number_of_beds(%{input: %{number_of_beds: number_of_beds}}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, success} <- Context.Bed.update_number_of_beds(current_hospital.id, number_of_beds) do
      {:ok, %{success: success}}
    end
  end

  def update_number_of_available_beds(
        %{input: %{number_of_available_beds: number_of_available_beds}},
        info
      ) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, success} <-
           Context.Bed.update_number_of_available_beds(
             current_hospital.id,
             number_of_available_beds
           ) do
      {:ok, %{success: success}}
    end
  end
end
