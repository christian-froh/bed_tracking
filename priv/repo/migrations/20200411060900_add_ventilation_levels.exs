defmodule BedTracking.Repo.Migrations.AddVentilationLevels do
  use Ecto.Migration

  def change do
    alter table(:beds) do
      add(:ventilation_type, :string)
      remove(:ventilator_in_use)
    end

    create(index(:beds, [:ventilation_type]))
  end
end
