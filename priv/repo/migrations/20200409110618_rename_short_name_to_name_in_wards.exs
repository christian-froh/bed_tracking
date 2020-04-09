defmodule BedTracking.Repo.Migrations.RenameShortNameToNameInWards do
  use Ecto.Migration

  def change do
    rename table("wards"), :short_name, to: :name
    rename table("wards"), :long_name, to: :description

    alter table(:wards) do
      add(:is_covid_ward, :boolean, default: false)
    end
  end
end
