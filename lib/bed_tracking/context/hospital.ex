defmodule BedTracking.Context.Hospital do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Hospital

  def get(hospital_manager) do
    Hospital
    |> Context.Hospital.Query.where_id(hospital_manager.hospital_id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.NotFoundError{fields: %{id: hospital_manager.hospital_id}, type: "Hospital"}}

      hospital ->
        {:ok, hospital}
    end
  end
end
