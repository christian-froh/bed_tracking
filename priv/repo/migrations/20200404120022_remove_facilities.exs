defmodule BedTracking.Repo.Migrations.RemoveFacilities do
  use Ecto.Migration

  def change do
    drop table(:facilities)

    alter table(:beds) do
      add(:covid_status, :string)
      add(:ventilator_in_use, :boolean, default: false)
    end
  end
end
