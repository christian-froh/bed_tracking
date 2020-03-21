defmodule BedTracking.Repo.Bed do
  use BedTracking.Repo.Schema
  alias BedTracking.Repo.Hospital

  schema "beds" do
    field(:available, :boolean)

    belongs_to(:hospital, Hospital)

    timestamps()
  end
end
