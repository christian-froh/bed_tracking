defmodule BedTracking.Repo.Migrations.AddTotalHemofilter do
  use Ecto.Migration

  def change do
    alter table(:hospitals) do
      add(:total_hemofilter, :integer)
    end
  end
end
