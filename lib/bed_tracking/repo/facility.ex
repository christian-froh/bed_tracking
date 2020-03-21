defmodule BedTracking.Repo.Facility do
  use BedTracking.Repo.Schema
  alias BedTracking.Repo.Hospital

  schema "facilities" do
    field(:name, :string)
    field(:available, :boolean)

    belongs_to(:hospital, Hospital)

    timestamps()
  end
end
