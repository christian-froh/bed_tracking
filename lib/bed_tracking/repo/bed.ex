defmodule BedTracking.Repo.Bed do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital
  alias BedTracking.Repo.Ward

  schema "beds" do
    field(:available, :boolean)
    field(:reference, :string)
    field(:active, :boolean)

    belongs_to(:hospital, Hospital)
    belongs_to(:ward, Ward)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :available,
      :active,
      :ward_id,
      :hospital_id
    ])
    |> validate_required([
      :ward_id,
      :hospital_id
    ])
  end

  def activate_changeset(struct, params) do
    struct
    |> cast(params, [
      :reference,
      :active
    ])
    |> validate_required([
      :reference
    ])
  end

  def deactivate_changeset(struct, params) do
    struct
    |> cast(params, [
      :active
    ])
    |> validate_required([
      :active
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
