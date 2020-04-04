defmodule BedTracking.Repo.Migrations.AddBedIndex do
  use Ecto.Migration

  def change do
    create(index(:beds, [:hospital_id]))
  end
end
