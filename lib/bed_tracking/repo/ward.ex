defmodule BedTracking.Repo.Ward do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Hospital

  schema "wards" do
    field(:name, :string)
    field(:description, :string)
    field(:total_beds, :integer)
    field(:available_beds, :integer)
    field(:is_covid_ward, :boolean)

    has_many(:beds, Bed, on_delete: :delete_all)
    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:name, :description, :is_covid_ward, :hospital_id])
    |> validate_required([:name, :hospital_id])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:name, :description, :is_covid_ward])
  end

  def update_number_of_beds_changeset(struct, params) do
    struct
    |> cast(params, [:total_beds, :available_beds])
    |> validate_required([:total_beds, :available_beds])
  end
end
