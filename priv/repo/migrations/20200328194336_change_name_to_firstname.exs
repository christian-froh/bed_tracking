defmodule BedTracking.Repo.Migrations.ChangeNameToFirstname do
  use Ecto.Migration

  def change do
    rename table(:hospital_managers), :name, to: :firstname

    alter table(:hospital_managers) do
      add(:lastname, :string)
      add(:phone_number, :string)
    end

    alter table(:hospitals) do
      modify :use_qr_code, :boolean, default: fragment("NULL"), null: true
    end
  end
end
