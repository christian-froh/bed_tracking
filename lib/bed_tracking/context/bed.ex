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

  def register_multiple(number_of_beds, ward_id, hospital_id) do
    with {:ok, beds} <- create_multiple_beds(number_of_beds, ward_id, hospital_id) do
      {:ok, beds}
    end
  end

  def register(ward_id, hospital_id) do
    with {:ok, bed} <- create_bed(ward_id, hospital_id) do
      {:ok, bed}
    end
  end

  def update(id, params) do
    with {:ok, bed} <- get_bed(id),
         {:ok, updated_bed} <- update_bed(bed, params) do
      {:ok, updated_bed}
    end
  end

  def remove(id) do
    with {:ok, bed} <- get_bed(id),
         {:ok, _deleted_bed} <- remove_bed(bed) do
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

  defp create_multiple_beds(number_of_beds, ward_id, hospital_id) do
    now = DateTime.utc_now()

    beds =
      1..number_of_beds
      |> Enum.map(fn number ->
        now = DateTime.add(now, number, :microsecond)

        %{
          available: true,
          ward_id: ward_id,
          hospital_id: hospital_id,
          inserted_at: now,
          updated_at: now
        }
      end)

    {_, beds} = BedTracking.Repo.insert_all(Bed, beds, returning: true)

    {:ok, beds}
  end

  defp create_bed(ward_id, hospital_id) do
    params = %{available: true, ward_id: ward_id, hospital_id: hospital_id}

    %Bed{}
    |> Bed.create_changeset(params)
    |> Repo.insert()
  end

  defp update_bed(bed, params) do
    bed
    |> Bed.update_changeset(params)
    |> Repo.update()
  end

  defp remove_bed(bed) do
    bed
    |> Repo.delete()
  end
end
