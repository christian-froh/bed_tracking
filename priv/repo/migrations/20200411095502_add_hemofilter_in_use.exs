defmodule BedTracking.Repo.Migrations.AddHemofilterInUse do
  use Ecto.Migration

  def change do
    alter table(:beds) do
      add(:hemofilter_in_use, :boolean, default: false)
    end

    create(index(:beds, [:hemofilter_in_use]))
  end
end
