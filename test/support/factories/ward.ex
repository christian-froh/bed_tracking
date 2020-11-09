defmodule BedTracking.Factory.Ward do
  defmacro __using__(_opts) do
    quote do
      def ward_factory do
        hospital = build(:hospital)

        %BedTracking.Repo.Ward{
          name: "Lung Ward",
          description: "The ward responsible for lungs",
          ward_type: "covid",
          hospital: hospital
        }
      end
    end
  end
end
