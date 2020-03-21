defmodule BedTracking.Repo.Hospital do
  use BedTracking.Repo.Schema
  alias BedTracking.Repo.Bed
  alias BedTracking.Repo.Facility

  schema "hospitals" do
    field(:name, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:address, :string)

    has_many(:beds, Bed)
    has_many(:facilities, Facility)

    timestamps()
  end
end
