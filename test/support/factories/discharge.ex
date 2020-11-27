defmodule BedTracking.Factory.Discharge do
  defmacro __using__(_opts) do
    quote do
      def discharge_factory do
        hospital = build(:hospital)

        %BedTracking.Repo.Discharge{
          reason: "death",
          hospital: hospital
        }
      end
    end
  end
end
