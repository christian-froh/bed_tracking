defmodule BedTracking.Repo.Migrations.AddUseQrToHospitals do
  use Ecto.Migration

  def change do
    alter table(:hospitals) do
      add(:use_qr_code, :boolean, default: false)
    end
  end
end
