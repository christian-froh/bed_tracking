defmodule BedTracking.Repo.Migrations.AddShortNameToWard do
  use Ecto.Migration

  def change do
    alter table(:wards) do
      add(:short_name, :string)
      add(:long_name, :string)
      remove(:name)
    end
  end
end
