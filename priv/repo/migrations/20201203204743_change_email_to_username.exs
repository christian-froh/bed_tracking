defmodule BedTracking.Repo.Migrations.ChangeEmailToUsername do
  use Ecto.Migration

  def change do
    rename table(:hospital_managers), :email, to: :username

    drop(unique_index(:hospital_managers, [:email]))
    create(unique_index(:hospital_managers, [:username]))
  end
end
