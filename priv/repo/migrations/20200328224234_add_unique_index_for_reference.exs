defmodule BedTracking.Repo.Migrations.AddUniqueIndexForReference do
  use Ecto.Migration

  def change do
    drop(unique_index(:beds, [:reference]))
  end
end
