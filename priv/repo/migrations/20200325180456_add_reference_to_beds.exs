defmodule BedTracking.Repo.Migrations.AddReferenceToBeds do
  use Ecto.Migration

  def change do
    alter table(:beds) do
      add(:reference, :string)
      add(:active, :boolean, default: false)
    end
  end
end
