defmodule BedTracking.Repo.Discharge do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital
  alias BedTracking.Repo.HospitalManager
  alias BedTracking.Repo.Ward

  schema "discharges" do
    field(:reason, :string)

    belongs_to(:ward, Ward)
    belongs_to(:hospital, Hospital)
    belongs_to(:updated_by_hospital_manager, HospitalManager)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :reason,
      :ward_id,
      :hospital_id,
      :updated_by_hospital_manager_id
    ])
    |> validate_required([
      :reason,
      :ward_id,
      :hospital_id,
      :updated_by_hospital_manager_id
    ])
  end
end
