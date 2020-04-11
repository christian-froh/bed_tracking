defmodule BedTracking.Repo.Bed do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital
  alias BedTracking.Repo.Ward

  schema "beds" do
    field(:available, :boolean)
    field(:covid_status, :string)
    field(:level_of_care, :string)
    field(:ventilation_type, :string)

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
    |> cast(params, [
      :available,
      :covid_status,
      :level_of_care,
      :ventilation_type
    ])
  end
end
