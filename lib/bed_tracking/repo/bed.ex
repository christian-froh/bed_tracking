defmodule BedTracking.Repo.Bed do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital

  schema "beds" do
    field(:available, :boolean)
    field(:reference, :string)
    field(:active, :boolean)

    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :available,
      :active,
      :hospital_id
    ])
    |> validate_required([
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
