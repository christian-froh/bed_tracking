defmodule BedTracking.Repo.Migrations.AddWardTypeToDischarges do
  use Ecto.Migration

  def change do
    alter table(:discharges) do
      add(:ward_type, :string)
    end
  end
end
