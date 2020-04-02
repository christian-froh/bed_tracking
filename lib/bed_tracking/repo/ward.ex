defmodule BedTracking.Repo.Ward do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Hospital

  schema "wards" do
    field(:name, :string)

    has_many(:beds, Bed)
    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:name, :hospital_id])
    |> validate_required([:name, :hospital_id])
  end
end
