defmodule BedTracking.Context.HospitalManager do
  alias BedTracking.Context
  alias BedTracking.Error
  alias BedTracking.Repo
  alias BedTracking.Repo.HospitalManager

  def create(params) do
    with {:ok, hospital_manager} <- create_hospital_manager(params) do
      {:ok, hospital_manager}
    end
  end

  defp create_hospital_manager(params) do
    %HospitalManager{}
    |> HospitalManager.create_changeset(params)
    |> Repo.insert()
  end
end
