defmodule BedTracking.Context.Bed do
  import Ecto.Query
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
    with {:ok, true} <- update_beds(hospital_id, number_of_beds) do
      {:ok, true}
    end
  end

  def update_number_of_available_beds(hospital_id, number_of_available_beds) do
    with {:ok, true} <- update_available_beds(hospital_id, number_of_available_beds) do
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

  defp update_beds(hospital_id, number_of_beds) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    current_total_beds =
      Bed
      |> Context.Bed.Query.where_hospital_id(hospital_id)
      |> Context.Bed.Query.count()
      |> Repo.one()

    number_of_available_beds =
      Bed
      |> Context.Bed.Query.where_hospital_id(hospital_id)
      |> Context.Bed.Query.where_available()
      |> Context.Bed.Query.count()
      |> Repo.one()

    BedTracking.Repo.delete_all(from(b in Bed, where: b.hospital_id == ^hospital_id))

    if number_of_beds > current_total_beds do
      available_beds =
        1..number_of_available_beds
        |> Enum.map(fn _number ->
          %{available: true, hospital_id: hospital_id, inserted_at: now, updated_at: now}
        end)

      BedTracking.Repo.insert_all(Bed, available_beds)

      if number_of_beds >= available_beds do
        not_available_beds =
          1..(number_of_beds - length(available_beds))
          |> Enum.map(fn _number ->
            %{available: false, hospital_id: hospital_id, inserted_at: now, updated_at: now}
          end)

        BedTracking.Repo.insert_all(Bed, not_available_beds)
      end
    else
      if number_of_beds > number_of_available_beds do
        available_beds =
          1..number_of_available_beds
          |> Enum.map(fn _number ->
            %{available: true, hospital_id: hospital_id, inserted_at: now, updated_at: now}
          end)

        BedTracking.Repo.insert_all(Bed, available_beds)

        not_available_beds =
          1..(number_of_beds - length(available_beds))
          |> Enum.map(fn _number ->
            %{available: false, hospital_id: hospital_id, inserted_at: now, updated_at: now}
          end)

        BedTracking.Repo.insert_all(Bed, not_available_beds)
      else
        available_beds =
          1..number_of_beds
          |> Enum.map(fn _number ->
            %{available: true, hospital_id: hospital_id, inserted_at: now, updated_at: now}
          end)

        BedTracking.Repo.insert_all(Bed, available_beds)
      end
    end

    {:ok, true}
  end

  defp update_available_beds(hospital_id, number_of_available_beds) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    current_total_beds =
      Bed
      |> Context.Bed.Query.where_hospital_id(hospital_id)
      |> Context.Bed.Query.count()
      |> Repo.one()

    if number_of_available_beds <= current_total_beds do
      BedTracking.Repo.delete_all(from(b in Bed, where: b.hospital_id == ^hospital_id))

      available_beds =
        1..number_of_available_beds
        |> Enum.map(fn _number ->
          %{available: true, hospital_id: hospital_id, inserted_at: now, updated_at: now}
        end)

      BedTracking.Repo.insert_all(Bed, available_beds)

      not_available_beds =
        1..(current_total_beds - length(available_beds))
        |> Enum.map(fn _number ->
          %{available: false, hospital_id: hospital_id, inserted_at: now, updated_at: now}
        end)

      BedTracking.Repo.insert_all(Bed, not_available_beds)
    end

    {:ok, true}
  end
end
