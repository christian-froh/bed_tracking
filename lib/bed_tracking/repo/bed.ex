defmodule BedTracking.Repo.Bed do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital
  alias BedTracking.Repo.Ward

  schema "beds" do
    field(:available, :boolean)
    field(:ventilator_in_use, :boolean)
    field(:covid_status, :string)

    belongs_to(:hospital, Hospital)
    belongs_to(:ward, Ward)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :available,
      :ward_id,
      :hospital_id
    ])
    |> validate_required([
      :ward_id,
      :hospital_id
    ])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:available, :ventilator_in_use, :covid_status])
  end
end
