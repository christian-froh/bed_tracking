defmodule BedTrackingGraphql.Resolver.Bed do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Error

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

  def activate(%{input: %{id: id, reference: reference}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.activate(id, reference) do
      {:ok, %{bed: bed}}
    end
  end

  def remove(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, success} <- Context.Bed.remove(id) do
      {:ok, %{success: success}}
    end
  end

  def update_availability(%{input: %{id: id, available: available}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.update_availability(id, available) do
      {:ok, %{bed: bed}}
    end
  end

  def update_number_of_beds(
        %{
          input: %{
            ward_id: ward_id,
            number_of_total_beds: number_of_total_beds,
            number_of_available_beds: number_of_available_beds
          }
        },
        info
      ) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, true} <-
           validate_update_number_of_beds(number_of_total_beds, number_of_available_beds),
         {:ok, success} <-
           Context.Bed.update_number_of_beds(
             ward_id,
             current_hospital.id,
             number_of_total_beds,
             number_of_available_beds
           ) do
      {:ok, %{success: success}}
    end
  end

  defp validate_update_number_of_beds(number_of_total_beds, number_of_available_beds) do
    if number_of_total_beds >= number_of_available_beds do
      {:ok, true}
    else
      {:error,
       %Error.ValidationError{
         reason: "Total number of beds has to be greater than available beds",
         details: "Total number of beds has to be greater than available beds",
         field: "number_of_available_beds"
       }}
    end
  end
end
