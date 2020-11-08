defmodule BedTrackingGraphql.Resolver.Bed do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get(%{input: %{id: id}}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, bed} <- Context.Bed.get(id) do
      {:ok, %{bed: bed}}
    end
  end

  def register_multiple(
        %{input: %{ward_id: ward_id, number_of_beds: number_of_beds} = params},
        info
      ) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, beds} <-
           Context.Bed.register_multiple(number_of_beds, ward_id, params, current_hospital.id) do
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

  def discharge_patient(
        %{input: %{id: id, reason: "internal_icu"} = params},
        info
      ) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, true} <- validate_params(params),
         {:ok, success} <- Context.Bed.discharge_patient(id, params) do
      {:ok, %{success: success}}
    end
  end

  def discharge_patient(%{input: %{id: id, reason: _reason} = params}, info) do
    with {:ok, _current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, success} <- Context.Bed.discharge_patient(id, params) do
      {:ok, %{success: success}}
    end
  end

  defp validate_params(%{bed_id: _bed_id}), do: {:ok, true}
  defp validate_params(_params), do: {:error, "bed_id is missing"}
end
