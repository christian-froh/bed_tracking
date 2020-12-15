defmodule BedTracking.Repo.Migrations.AddIsAdminToHospitalManagers do
  use Ecto.Migration

  def change do
    alter table(:hospital_managers) do
      add(:is_admin, :boolean, default: false)
    end
  end
end
