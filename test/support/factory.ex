defmodule BedTracking.Factory do
  use ExMachina.Ecto, repo: BedTracking.Repo

  use BedTracking.Factory.{
    Bed,
    Hospital,
    HospitalManager,
    Ward
  }
end
