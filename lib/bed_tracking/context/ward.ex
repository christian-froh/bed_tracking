defmodule BedTracking.Context.Ward do
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
end
