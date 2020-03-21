defmodule BedTrackingGraphql.Resolver.Hospital do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get_hospitals(_params, _info) do
    with {:ok, hospitals} <- Context.Hospital.list() do
      {:ok, %{hospitals: hospitals}}
    end
  end
end
