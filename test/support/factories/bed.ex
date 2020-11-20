defmodule BedTracking.Factory.Bed do
  defmacro __using__(_opts) do
    quote do
      def bed_factory do
        hospital = build(:hospital)
        ward = build(:ward)
        hospital_manager = build(:hospital_manager)

        %BedTracking.Repo.Bed{
          available: true,
          covid_status: nil,
          level_of_care: nil,
          ventilation_type: nil,
          reference: nil,
          initials: nil,
          sex: nil,
          date_of_admission: nil,
          source_of_admission: nil,
          use_tracheostomy: nil,
          rrt_type: nil,
          hospital: hospital,
          ward: ward,
          updated_by_hospital_manager: hospital_manager
        }
      end
    end
  end
end
