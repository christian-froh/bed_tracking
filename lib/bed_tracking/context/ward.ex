defmodule BedTracking.Context.Ward do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Ward

  def create(name, hospital_id) do
    with {:ok, ward} <- create_ward(name, hospital_id) do
      {:ok, ward}
    end
  end

  defp create_ward(name, hospital_id) do
    params = %{name: name, hospital_id: hospital_id}

    %Ward{}
    |> Ward.create_changeset(params)
    |> Repo.insert()
  end

  def update_number_of_beds(ward_id, number_of_total_beds, number_of_available_beds) do
    with {:ok, ward} <- get_ward(ward_id),
         {:ok, updated_ward} <-
           update_beds(ward, number_of_total_beds, number_of_available_beds) do
      {:ok, updated_ward}
    end
  end

  defp get_ward(id) do
    Ward
    |> Context.Ward.Query.where_id(id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.NotFoundError{fields: %{id: id}, type: "Ward"}}

      ward ->
        {:ok, ward}
    end
  end

  defp update_beds(ward, number_of_total_beds, number_of_available_beds) do
    params = %{total_beds: number_of_total_beds, available_beds: number_of_available_beds}

    ward
    |> Ward.update_number_of_beds_changeset(params)
    |> Repo.update()
  end
end
