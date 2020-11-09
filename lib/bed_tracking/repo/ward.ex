defmodule BedTracking.Repo.Ward do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Hospital

  schema "wards" do
    field(:name, :string)
    field(:description, :string)
    field(:ward_type, :string)
    field(:is_surge_ward, :boolean, default: false)
    field(:number_of_critcare_nurses, :integer)
    field(:number_of_other_rns, :integer)
    field(:number_of_nurse_support_staff, :integer)
    field(:max_admission_capacity, :integer)
    field(:can_provide_ics_ratios, :boolean)

    has_many(:beds, Bed, on_delete: :delete_all)
    belongs_to(:hospital, Hospital)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :name,
      :description,
      :ward_type,
      :is_surge_ward,
      :number_of_critcare_nurses,
      :number_of_other_rns,
      :number_of_nurse_support_staff,
      :max_admission_capacity,
      :can_provide_ics_ratios,
      :hospital_id
    ])
    |> validate_required([:name, :ward_type, :hospital_id])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [
      :name,
      :description,
      :ward_type,
      :is_surge_ward,
      :number_of_critcare_nurses,
      :number_of_other_rns,
      :number_of_nurse_support_staff,
      :max_admission_capacity,
      :can_provide_ics_ratios
    ])
  end
end
