defmodule BedTracking.Repo.Migrations.AddWardTypeToWards do
  use Ecto.Migration

  def change do
    alter table(:wards) do
      remove(:is_covid_ward)
      add(:ward_type, :string)
      add(:is_surge_ward, :boolean)
      add(:number_of_critcare_nurses, :integer)
      add(:number_of_other_rns, :integer)
      add(:number_of_nurse_support_staff, :integer)
      add(:max_admission_capacity, :integer)
      add(:can_provide_ics_ratios, :boolean)
    end
  end
end
