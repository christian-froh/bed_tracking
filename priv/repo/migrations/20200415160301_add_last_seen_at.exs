defmodule BedTracking.Repo.Migrations.AddLastSeenAt do
  use Ecto.Migration

  def change do
    alter table(:hospital_managers) do
      add(:last_login_at, :utc_datetime)
    end
  end
end
