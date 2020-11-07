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
    field(:reference, :string)
    field(:initials, :string)
    field(:sex, :string)
    field(:date_of_admission, :utc_datetime)
    field(:source_of_admission, :string)
    field(:use_tracheostomy, :boolean)
    field(:rtt_type, :string)

    belongs_to(:hospital, Hospital)
    belongs_to(:ward, Ward)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :available,
      :ward_id,
      :reference,
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
      :ventilation_type,
      :reference,
      :initials,
      :sex,
      :date_of_admission,
      :source_of_admission,
      :use_tracheostomy,
      :rtt_type
    ])
    |> clean_bed_if_available_set_to_true()
  end

  def clean_changeset(struct) do
    struct
    |> cast(%{}, [])
    |> clean_bed()
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
    |> set_field_to(:rtt_type, nil)
  end

  defp set_field_to(changeset, field, value) do
    put_change(changeset, field, value)
  end
end
