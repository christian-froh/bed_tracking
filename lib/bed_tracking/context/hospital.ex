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

  def use_management_system(use_management, hospital_id) do
    with {:ok, hospital} <- get(hospital_id),
         {:ok, updated_hospital} <- update_use_management(use_management, hospital) do
      {:ok, updated_hospital}
    end
  end

  defp create_hospital(params) do
    %Hospital{}
    |> Hospital.create_changeset(params)
    |> Repo.insert()
  end

  defp update_use_management(use_management, hospital) do
    params = %{use_management: use_management}

    Hospital.use_management_changeset(hospital, params)
    |> Repo.update()
  end
end
