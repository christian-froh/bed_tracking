defmodule BedTracking.Factory do
  use ExMachina.Ecto, repo: BedTracking.Repo

  use BedTracking.Factory.{
    Hospital,
    HospitalManager
  }
end
