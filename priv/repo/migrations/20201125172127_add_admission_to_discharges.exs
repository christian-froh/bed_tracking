defmodule BedTracking.Repo.Migrations.AddAdmissionToDischarges do
  use Ecto.Migration

  def change do
    alter table(:discharges) do
      add(:date_of_admission, :utc_datetime)
      add(:source_of_admission, :string)
    end
  end
end
