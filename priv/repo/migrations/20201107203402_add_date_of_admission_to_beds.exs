defmodule BedTracking.Repo.Migrations.AddDateOfAdmissionToBeds do
  use Ecto.Migration

  def change do
    alter table(:beds) do
      add(:date_of_admission, :utc_datetime)
      add(:source_of_admission, :string)
      add(:use_tracheostomy, :boolean)
      add(:rtt_type, :string)
      remove(:hemofilter_in_use)
    end

    alter table(:hospitals) do
      remove(:use_management)
      remove(:total_hemofilter)
    end

    alter table(:wards) do
      remove(:total_beds)
      remove(:available_beds)
    end

    create table(:discharges, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:reason, :string)

      add(:hospital_id, references(:hospitals, type: :uuid))
      add(:ward_id, references(:wards, type: :uuid))

      timestamps(type: :utc_datetime)
    end
  end
end
