defmodule BedTracking.Repo.Hospital do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Facility
  alias BedTracking.Repo.HospitalManager
  alias BedTracking.Repo.Ward

  schema "hospitals" do
    field(:name, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:address, :string)
    field(:use_qr_code, :boolean)

    has_many(:wards, Ward)
    has_many(:facilities, Facility)
    has_many(:hospital_managers, HospitalManager)
    has_many(:beds, Bed)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :name,
      :latitude,
      :longitude,
      :address
    ])
    |> validate_required([
      :name,
      :latitude,
      :longitude,
      :address
    ])
  end

  def use_qr_code_changeset(struct, params) do
    struct
    |> cast(params, [:use_qr_code])
    |> validate_required([:use_qr_code])
  end
end
