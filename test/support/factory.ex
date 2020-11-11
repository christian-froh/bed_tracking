defmodule BedTracking.Factory do
  use ExMachina.Ecto, repo: BedTracking.Repo

  use BedTracking.Factory.{
    Bed,
    Discharge,
    Hospital,
    HospitalManager,
    Ward
  }
end
