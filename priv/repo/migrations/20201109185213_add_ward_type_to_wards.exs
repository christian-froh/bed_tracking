defmodule BedTracking.Repo.Migrations.AddWardTypeToWards do
  use Ecto.Migration

  def change do
    alter table(:wards) do
      remove(:is_covid_ward)
      add(:ward_type, :string)
    end
  end
end
