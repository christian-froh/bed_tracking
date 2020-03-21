defmodule BedTracking.Context.Hospital.Get do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Hospital

  def call(hospital_id) do
    Hospital
    |> Context.Hospital.Query.where_id(hospital_id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.NotFoundError{fields: %{id: hospital_id}, type: "Hospital"}}

      hospital ->
        {:ok, hospital}
    end
  end
end
