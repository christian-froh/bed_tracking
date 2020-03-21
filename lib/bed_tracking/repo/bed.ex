defmodule BedTracking.Repo.Bed do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital

  schema "beds" do
    field(:available, :boolean)

    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :available,
      :hospital_id
    ])
    |> validate_required([
      :available,
      :hospital_id
    ])
  end

  def update_availability_changeset(struct, params) do
    struct
    |> cast(params, [
      :available
    ])
    |> validate_required([
      :available
    ])
  end
end
