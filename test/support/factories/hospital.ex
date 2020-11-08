defmodule BedTracking.Factory.Hospital do
  defmacro __using__(_opts) do
    quote do
      def hospital_factory do
        %BedTracking.Repo.Hospital{
          name: "Free Royal Hospital",
          latitude: 51.5350857,
          longitude: -0.1404352,
          address: "Pond St, Hampstead, London NW3 2QG, Vereinigtes Königreich"
        }
      end
    end
  end
end
