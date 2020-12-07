defmodule BedTracking.Repo.Migrations.AddIsChangedPasswordToHospitalManagers do
  use Ecto.Migration

  def change do
    alter table(:hospital_managers) do
      add(:is_changed_password, :boolean, default: false)
    end
  end
end
