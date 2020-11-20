defmodule BedTracking.Factory.Ward do
  defmacro __using__(_opts) do
    quote do
      def ward_factory do
        hospital = build(:hospital)
        hospital_manager = build(:hospital_manager)

        %BedTracking.Repo.Ward{
          name: "Lung Ward",
          description: "The ward responsible for lungs",
          ward_type: "covid",
          is_surge_ward: false,
          number_of_critcare_nurses: 5,
          number_of_other_rns: 5,
          number_of_nurse_support_staff: 5,
          max_admission_capacity: 5,
          hospital: hospital,
          updated_by_hospital_manager: hospital_manager
        }
      end
    end
  end
end
