defmodule BedTracking.Repo.Migrations.CreateAdminsTable do
  use Ecto.Migration

  def change do
    create table(:admins, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:email, :string)
      add(:name, :string)
      add(:password_hash, :string)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:admins, [:email]))
  end
end
