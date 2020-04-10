defmodule BedTracking.Repo.Migrations.AddLevelOfCare do
  use Ecto.Migration

  def change do
    alter table(:beds) do
      add(:level_of_care, :string)
    end

    create(index(:beds, [:level_of_care]))
  end
end
