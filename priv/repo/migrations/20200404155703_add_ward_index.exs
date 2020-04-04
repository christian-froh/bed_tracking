defmodule BedTracking.Repo.Migrations.AddWardIndex do
  use Ecto.Migration

  def change do
    create(index(:beds, [:active]))
    create(index(:beds, [:ward_id]))
    create(index(:beds, [:ventilator_in_use]))
    create(index(:beds, [:covid_status]))
  end
end
