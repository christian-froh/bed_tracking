defmodule BedTrackingGraphql.Resolver.Bed do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def register(%{input: %{hospital_id: hospital_id}}, _info) do
    with {:ok, bed} <- Context.Bed.register(hospital_id) do
      {:ok, %{bed: bed}}
    end
  end
end
