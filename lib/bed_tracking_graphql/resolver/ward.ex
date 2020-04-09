defmodule BedTrackingGraphql.Resolver.Ward do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context
  alias BedTracking.Error

  def create(%{input: %{name: _name} = params}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, ward} <- Context.Ward.create(params, current_hospital.id) do
      {:ok, %{ward: ward}}
    end
  end

  def update(%{input: %{id: id} = params}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, ward} <- Context.Ward.update(id, params) do
      {:ok, %{ward: ward}}
    end
  end

  def remove(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, success} <- Context.Ward.remove(id) do
      {:ok, %{success: success}}
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
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, true} <-
           validate_update_number_of_beds(number_of_total_beds, number_of_available_beds),
         {:ok, ward} <-
           Context.Ward.update_number_of_beds(
             ward_id,
             number_of_total_beds,
             number_of_available_beds
           ) do
      {:ok, %{ward: ward}}
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
