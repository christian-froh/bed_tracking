defmodule BedTracking.Repo.Migrations.AddNameToFacilities do
  use Ecto.Migration

  def change do
    alter table(:facilities) do
      add(:name, :string)
    end
  end
end
