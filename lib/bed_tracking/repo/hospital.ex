defmodule BedTracking.Repo.Hospital do
  use BedTracking.Repo.Schema
  import Ecto.Changeset
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Facility

  schema "hospitals" do
    field(:name, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:address, :string)
    field(:use_qr_code, :boolean)

    has_many(:beds, Bed)
    has_many(:facilities, Facility)

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
