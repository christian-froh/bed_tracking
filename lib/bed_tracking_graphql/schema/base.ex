defmodule BedTrackingGraphql.Schema.Base do
  defmacro __using__(_) do
    quote do
      use Absinthe.Schema.Notation
      import Absinthe.Resolution.Helpers
      alias BedTracking.Repo
      alias BedTrackingGraphql.Resolver
    end
  end
end
