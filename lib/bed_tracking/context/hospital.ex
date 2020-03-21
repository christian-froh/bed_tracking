defmodule BedTracking.Context.Hospital do
  def list(), do: BedTracking.Context.Hospital.List.call()
end
