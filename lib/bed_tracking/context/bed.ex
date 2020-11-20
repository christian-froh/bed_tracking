defmodule BedTracking.Context.Bed do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Discharge

  def get(id) do
    with {:ok, bed} <- get_bed(id) do
      {:ok, bed}
    end
  end

  def register_multiple(number_of_beds, ward_id, params, hospital_manager) do
    with {:ok, beds} <- create_multiple_beds(number_of_beds, ward_id, params, hospital_manager) do
      {:ok, beds}
    end
  end

  def register(ward_id, hospital_manager) do
    with {:ok, bed} <- create_bed(ward_id, hospital_manager) do
      {:ok, bed}
    end
  end

  def update(id, params, hospital_manager) do
    with {:ok, bed} <- get_bed(id),
         {:ok, updated_bed} <- update_bed(bed, params, hospital_manager) do
      {:ok, updated_bed}
    end
  end

  def remove(id) do
    with {:ok, bed} <- get_bed(id),
         {:ok, _deleted_bed} <- remove_bed(bed) do
      {:ok, true}
    end
  end

  def discharge_patient(id, %{reason: reason} = params, hospital_manager) do
    with {:ok, bed} <- get_bed(id),
         {:ok, _bed} <- move_to_another_bed_if_reason_internal_icu(bed, params, hospital_manager),
         {:ok, _discharge} <- create_discharge(bed.ward_id, bed.hospital_id, reason, hospital_manager),
         {:ok, _deleted_bed} <- clean_bed(bed, hospital_manager) do
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

  defp create_multiple_beds(number_of_beds, ward_id, params, hospital_manager) do
    now = DateTime.utc_now()

    beds =
      1..number_of_beds
      |> Enum.map(fn number ->
        now = DateTime.add(now, number, :microsecond)

        %{
          available: true,
          ward_id: ward_id,
          hospital_id: hospital_manager.hospital_id,
          updated_by_hospital_manager_id: hospital_manager.id,
          inserted_at: now,
          updated_at: now
        }
        |> add_reference(params, number)
      end)

    {_, beds} = BedTracking.Repo.insert_all(Bed, beds, returning: true)

    {:ok, beds}
  end

  defp add_reference(bed_params, %{start_from: start_from} = params, index)
       when is_integer(start_from) do
    reference = Integer.to_string(start_from + (index - 1))

    reference =
      if params[:prefix] != nil do
        params[:prefix] <> " " <> reference
      else
        reference
      end

    Map.merge(bed_params, %{reference: reference})
  end

  defp add_reference(bed_params, _params, _index), do: bed_params

  defp create_bed(ward_id, hospital_manager) do
    params = %{available: true, ward_id: ward_id, hospital_id: hospital_manager.hospital_id, updated_by_hospital_manager_id: hospital_manager.id}

    %Bed{}
    |> Bed.create_changeset(params)
    |> Repo.insert()
  end

  defp update_bed(bed, params, hospital_manager) do
    Map.merge(params, %{updated_by_hospital_manager_id: hospital_manager.id})

    bed
    |> Bed.update_changeset(params)
    |> Repo.update()
  end

  defp remove_bed(bed) do
    bed
    |> Repo.delete()
  end

  defp clean_bed(bed, hospital_manager) do
    params = %{updated_by_hospital_manager_id: hospital_manager.id}

    bed
    |> Bed.clean_changeset(params)
    |> Repo.update()
  end

  defp create_discharge(_ward_id, _hospital_id, "internal_icu", _hospital_manager), do: {:ok, :noop}

  defp create_discharge(ward_id, hospital_id, reason, hospital_manager) do
    params = %{ward_id: ward_id, hospital_id: hospital_id, reason: reason, updated_by_hospital_manager_id: hospital_manager.id}

    %Discharge{}
    |> Discharge.create_changeset(params)
    |> Repo.insert()
  end

  defp move_to_another_bed_if_reason_internal_icu(bed, %{reason: "internal_icu", bed_id: bed_id}, hospital_manager) do
    with {:ok, bed_to_move_to} <- get_bed(bed_id),
         {:ok, true} <- bed_available?(bed_to_move_to),
         {:ok, updated_bed} <- move_bed(bed, bed_to_move_to, hospital_manager) do
      {:ok, updated_bed}
    end
  end

  defp move_to_another_bed_if_reason_internal_icu(_bed, _params, _hospital_manager), do: {:ok, :noop}

  defp bed_available?(%{available: true}), do: {:ok, true}
  defp bed_available?(bed), do: {:error, %Error.BedAlreadyInUseError{bed_id: bed.id}}

  defp move_bed(old_bed, new_bed, hospital_manager) do
    params = %{updated_by_hospital_manager_id: hospital_manager.id}

    new_bed
    |> Bed.move_changeset(params, old_bed)
    |> Repo.update()
  end
end
