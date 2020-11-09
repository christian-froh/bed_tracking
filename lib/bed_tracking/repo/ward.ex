defmodule BedTracking.Repo.Ward do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Hospital

  schema "wards" do
    field(:name, :string)
    field(:description, :string)
    field(:ward_type, :string)

    has_many(:beds, Bed, on_delete: :delete_all)
    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:name, :description, :ward_type, :hospital_id])
    |> validate_required([:name, :ward_type, :hospital_id])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:name, :description, :ward_type])
  end
end
