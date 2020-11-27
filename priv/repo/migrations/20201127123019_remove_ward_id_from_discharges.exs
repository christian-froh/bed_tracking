defmodule BedTracking.Repo.Migrations.RemoveWardIdFromDischarges do
  use Ecto.Migration

  def change do
    alter table(:discharges) do
      remove(:ward_id)
    end
  end
end
