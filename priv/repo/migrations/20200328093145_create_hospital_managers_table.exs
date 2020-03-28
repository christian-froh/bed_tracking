defmodule BedTracking.Repo.Migrations.CreateHospitalManagersTable do
  use Ecto.Migration

  def change do
    create table(:hospital_managers, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:email, :string)
      add(:name, :string)
      add(:password_hash, :string)
      add(:hospital_id, references(:hospitals, type: :uuid))

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:hospital_managers, [:email]))
  end
end
