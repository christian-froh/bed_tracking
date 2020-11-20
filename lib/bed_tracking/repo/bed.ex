defmodule BedTracking.Repo.Bed do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Hospital
  alias BedTracking.Repo.HospitalManager
  alias BedTracking.Repo.Ward

  schema "beds" do
    field(:available, :boolean)
    field(:covid_status, :string)
    field(:level_of_care, :string)
    field(:ventilation_type, :string)
    field(:reference, :string)
    field(:initials, :string)
    field(:sex, :string)
    field(:date_of_admission, :utc_datetime)
    field(:source_of_admission, :string)
    field(:use_tracheostomy, :boolean)
    field(:rrt_type, :string)

    belongs_to(:hospital, Hospital)
    belongs_to(:ward, Ward)
    belongs_to(:updated_by_hospital_manager, HospitalManager)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :available,
      :ward_id,
      :reference,
      :hospital_id,
      :updated_by_hospital_manager_id
    ])
    |> validate_required([
      :ward_id,
      :hospital_id,
      :updated_by_hospital_manager_id
    ])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [
      :available,
      :covid_status,
      :level_of_care,
      :ventilation_type,
      :reference,
      :initials,
      :sex,
      :date_of_admission,
      :source_of_admission,
      :use_tracheostomy,
      :rrt_type,
      :updated_by_hospital_manager_id
    ])
    |> validate_required([
      :updated_by_hospital_manager_id
    ])
    |> clean_bed_if_available_set_to_true()
  end

  def clean_changeset(struct, params) do
    struct
    |> cast(params, [:updated_by_hospital_manager_id])
    |> validate_required([:updated_by_hospital_manager_id])
    |> clean_bed()
  end

  def move_changeset(struct, params, old_bed) do
    struct
    |> cast(params, [:updated_by_hospital_manager_id])
    |> validate_required([:updated_by_hospital_manager_id])
    |> set_field_to(:available, false)
    |> set_field_to(:covid_status, old_bed.covid_status)
    |> set_field_to(:level_of_care, old_bed.level_of_care)
    |> set_field_to(:ventilation_type, old_bed.ventilation_type)
    |> set_field_to(:initials, old_bed.initials)
    |> set_field_to(:sex, old_bed.sex)
    |> set_field_to(:date_of_admission, old_bed.date_of_admission)
    |> set_field_to(:source_of_admission, old_bed.source_of_admission)
    |> set_field_to(:use_tracheostomy, old_bed.use_tracheostomy)
    |> set_field_to(:rrt_type, old_bed.rrt_type)
  end

  defp clean_bed_if_available_set_to_true(changeset) do
    changeset
    |> fetch_change(:available)
    |> case do
      {:ok, true} ->
        changeset
        |> clean_bed()

      _ ->
        changeset
    end
  end

  defp clean_bed(changeset) do
    changeset
    |> set_field_to(:available, true)
    |> set_field_to(:covid_status, nil)
    |> set_field_to(:level_of_care, nil)
    |> set_field_to(:ventilation_type, nil)
    |> set_field_to(:initials, nil)
    |> set_field_to(:sex, nil)
    |> set_field_to(:date_of_admission, nil)
    |> set_field_to(:source_of_admission, nil)
    |> set_field_to(:use_tracheostomy, nil)
    |> set_field_to(:rrt_type, nil)
  end

  defp set_field_to(changeset, field, value) do
    put_change(changeset, field, value)
  end
end
