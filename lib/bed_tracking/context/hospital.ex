defmodule BedTracking.Context.Hospital do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Hospital

  def list() do
    hospitals =
      Hospital
      |> Repo.all()

    {:ok, hospitals}
  end

  def get(hospital_id) do
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
