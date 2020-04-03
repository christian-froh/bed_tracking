defmodule BedTracking.Repo.Migrations.AddNumberBedsToWards do
  use Ecto.Migration

  def change do
    alter table(:wards) do
      add(:total_beds, :integer, default: 0)
      add(:available_beds, :integer, default: 0)
    end
  end
end
