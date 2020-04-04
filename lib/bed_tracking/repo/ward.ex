defmodule BedTracking.Repo.Ward do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Hospital

  schema "wards" do
    field(:short_name, :string)
    field(:long_name, :string)
    field(:total_beds, :integer)
    field(:available_beds, :integer)

    has_many(:beds, Bed)
    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:short_name, :long_name, :hospital_id])
    |> validate_required([:short_name, :hospital_id])
  end

  def update_number_of_beds_changeset(struct, params) do
    struct
    |> cast(params, [:total_beds, :available_beds])
    |> validate_required([:total_beds, :available_beds])
  end
end
