defmodule BedTracking.Repo.Migrations.AddUniqIndexReference do
  use Ecto.Migration

  def change do
    create(unique_index(:beds, [:reference]))
  end
end
