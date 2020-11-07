defmodule BedTracking.Repo.Discharge do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital
  alias BedTracking.Repo.Ward

  schema "discharges" do
    field(:reason, :string)

    belongs_to(:ward, Ward)
    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :reason,
      :ward_id,
      :hospital_id
    ])
    |> validate_required([
      :reason,
      :ward_id,
      :hospital_id
    ])
  end
end
