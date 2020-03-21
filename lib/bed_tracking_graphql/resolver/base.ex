defmodule BedTrackingGraphql.Resolver.Base do
  defmacro __using__(_) do
    quote do
      import Absinthe.Resolution.Helpers
    end
  end
end
