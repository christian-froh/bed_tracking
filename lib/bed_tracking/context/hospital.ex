defmodule BedTracking.Context.Hospital do
  def list(), do: BedTracking.Context.Hospital.List.call()
  def get(hospital_id), do: BedTracking.Context.Hospital.Get.call(hospital_id)
end
