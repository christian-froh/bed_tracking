defmodule BedTracking.Repo.Migrations.AddReferenceInitialsSexToBeds do
  use Ecto.Migration

  def change do
    alter table(:beds) do
      add(:reference, :string)
      add(:initials, :string)
      add(:sex, :string)
    end

    create(index(:beds, [:reference]))
  end
end
