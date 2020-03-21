defmodule BedTracking.Repo.Migrations.CreateHospital do
  use Ecto.Migration

  def change do
    create table(:hospitals, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:latitude, :float)
      add(:longitude, :float)
      add(:address, :string)

      timestamps(type: :utc_datetime)
    end

    create table(:beds, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:available, :boolean)
      add(:hospital_id, references(:hospitals, type: :uuid))

      timestamps(type: :utc_datetime)
    end

    create table(:facilities, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:available, :boolean)
      add(:hospital_id, references(:hospitals, type: :uuid))

      timestamps(type: :utc_datetime)
    end

    create(index(:beds, [:available]))
    create(index(:facilities, [:available]))
  end
end
