defmodule BedTracking.Context.Hospital.List do
  alias BedTracking.Repo
  alias BedTracking.Repo.Hospital

  def call() do
    hospitals =
      Hospital
      |> Repo.all()

    {:ok, hospitals}
  end
end
