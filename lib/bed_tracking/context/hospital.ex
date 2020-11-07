defmodule BedTracking.Context.Hospital do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Hospital

  def list() do
    hospitals =
      Hospital
      |> Context.Hospital.Query.ordered_by(:asc, :name)
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

  def create(params) do
    with {:ok, hospital} <- create_hospital(params) do
      {:ok, hospital}
    end
  end

  defp create_hospital(params) do
    %Hospital{}
    |> Hospital.create_changeset(params)
    |> Repo.insert()
  end
end
