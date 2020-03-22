defmodule BedTracking.Context.Bed do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed

  def get(id) do
    with {:ok, bed} <- get_bed(id) do
      {:ok, bed}
    end
  end

  def register(hospital_id) do
    with {:ok, bed} <- create_bed(hospital_id) do
      {:ok, bed}
    end
  end

  def update_availability(id, available) do
    with {:ok, bed} <- get_bed(id),
         {:ok, updated_bed} <- update_bed(bed, available) do
      {:ok, updated_bed}
    end
  end

  def update_number_of_beds(hospital_id, number_of_beds) do
    with {:ok, true} <- update_number_of_bed(hospital_id, number_of_beds) do
      {:ok, true}
    end
  end

  def update_number_of_available_beds(hospital_id, number_of_available_beds) do
    with {:ok, true} <- update_number_of_available_bed(hospital_id, number_of_available_beds) do
      {:ok, true}
    end
  end

  defp get_bed(id) do
    Bed
    |> Context.Bed.Query.where_id(id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, %Error.NotFoundError{fields: %{id: id}, type: "Bed"}}

      bed ->
        {:ok, bed}
    end
  end

  defp create_bed(hospital_id) do
    params = %{available: true, hospital_id: hospital_id}

    %Bed{}
    |> Bed.create_changeset(params)
    |> Repo.insert()
  end

  defp update_bed(bed, available) do
    params = %{available: available}

    bed
    |> Bed.update_availability_changeset(params)
    |> Repo.update()
  end

  defp update_number_of_bed(hospital_id, number_of_beds) do
    {:ok, true}
  end

  defp update_number_of_available_bed(hospital_id, number_of_beds) do
    {:ok, true}
  end
end
