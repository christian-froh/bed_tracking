defmodule BedTracking.Factory.Bed do
  defmacro __using__(_opts) do
    quote do
      def bed_factory do
        hospital = build(:hospital)
        ward = build(:ward)

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
          rtt_type: nil,
          hospital: hospital,
          ward: ward
        }
      end
    end
  end
end
