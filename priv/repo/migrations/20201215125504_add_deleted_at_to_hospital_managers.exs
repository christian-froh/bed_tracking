defmodule BedTracking.Repo.Migrations.AddDeletedAtToHospitalManagers do
  use Ecto.Migration

  def change do
    alter table(:hospital_managers) do
      add(:deleted_at, :utc_datetime)
    end

    create(index(:hospital_managers, [:deleted_at]))
  end
end
