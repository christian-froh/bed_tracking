defmodule BedTracking.Factory.Discharge do
  defmacro __using__(_opts) do
    quote do
      def discharge_factory do
        hospital = build(:hospital)
        ward = build(:ward)

        %BedTracking.Repo.Discharge{
          reason: "death",
          hospital: hospital,
          ward: ward
        }
      end
    end
  end
end
