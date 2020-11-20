defmodule BedTracking.Context.Ward do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.Ward

  def create(params, hospital_manager) do
    with {:ok, ward} <- create_ward(params, hospital_manager) do
      {:ok, ward}
    end
  end

  def update(id, params, hospital_manager) do
    with {:ok, ward} <- get_ward(id),
         {:ok, ward} <- update_ward(ward, params, hospital_manager) do
      {:ok, ward}
    end
  end

  def remove(id) do
    with {:ok, ward} <- get_ward(id),
         {:ok, _deleted_ward} <- remove_ward(ward) do
      {:ok, true}
    end
  end

  defp create_ward(params, hospital_manager) do
    params = Map.merge(params, %{hospital_id: hospital_manager.hospital_id, updated_by_hospital_manager_id: hospital_manager.id})

    %Ward{}
    |> Ward.create_changeset(params)
    |> Repo.insert()
  end

  defp update_ward(ward, params, hospital_manager) do
    params = Map.merge(params, %{updated_by_hospital_manager_id: hospital_manager.id})

    ward
    |> Ward.update_changeset(params)
    |> Repo.update()
  end

  defp remove_ward(ward) do
    ward
    |> Repo.delete()
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
end
