defmodule BedTracking.Context.Bed do
  alias BedTracking.Repo
  alias BedTracking.Repo.Bed

  def register(hospital_id) do
    with {:ok, bed} <- create_bed(hospital_id) do
      {:ok, bed}
    end
  end

  defp create_bed(hospital_id) do
    params = %{available: true, hospital_id: hospital_id}

    %Bed{}
    |> Bed.create_changeset(params)
    |> Repo.insert()
  end
end
