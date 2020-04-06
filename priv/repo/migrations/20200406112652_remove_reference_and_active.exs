defmodule BedTracking.Repo.Migrations.RemoveReferenceAndActive do
  use Ecto.Migration

  def change do
    alter table(:beds) do
      remove(:reference)
      remove(:active)
    end
  end
end
