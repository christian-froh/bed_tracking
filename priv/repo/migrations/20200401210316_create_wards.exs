defmodule BedTracking.Repo.Migrations.CreateWards do
  use Ecto.Migration

  def change do
    create table(:wards, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)

      add(:hospital_id, references(:hospitals, type: :uuid))

      timestamps(type: :utc_datetime)
    end

    alter table(:beds) do
      add(:ward_id, references(:wards, type: :uuid))
    end

    create(unique_index(:wards, [:name]))
  end
end
