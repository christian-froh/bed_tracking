defmodule BedTracking.Repo.Migrations.ChangeTimestampToUsec do
  use Ecto.Migration

  def change do
    modify_timestamps(:admins)
    modify_timestamps(:beds)
    modify_timestamps(:hospital_managers)
    modify_timestamps(:hospitals)
    modify_timestamps(:wards)
  end

  def modify_timestamps(table) do
    alter table(table) do
      modify(:inserted_at, :utc_datetime_usec)
      modify(:updated_at, :utc_datetime_usec)
    end
  end
end
