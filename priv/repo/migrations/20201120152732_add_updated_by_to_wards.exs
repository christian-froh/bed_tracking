defmodule BedTracking.Repo.Migrations.AddUpdatedByToWards do
  use Ecto.Migration

  def change do
    alter table(:wards) do
      add(:updated_by_hospital_manager_id, references(:hospital_managers, type: :uuid))
    end

    alter table(:beds) do
      add(:updated_by_hospital_manager_id, references(:hospital_managers, type: :uuid))
    end

    alter table(:discharges) do
      add(:updated_by_hospital_manager_id, references(:hospital_managers, type: :uuid))
    end

    drop table(:admins)
  end
end
