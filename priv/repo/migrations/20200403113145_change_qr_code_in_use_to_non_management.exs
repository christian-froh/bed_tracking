defmodule BedTracking.Repo.Migrations.ChangeQrCodeInUseToNonManagement do
  use Ecto.Migration

  def change do
    rename table(:hospitals), :use_qr_code, to: :use_management
  end
end
