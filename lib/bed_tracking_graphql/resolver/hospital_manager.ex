defmodule BedTrackingGraphql.Resolver.HospitalManager do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def create(%{input: %{name: _, email: _, password: _, hospital_id: _} = params}, info) do
    with {:ok, _current_admin} <- Context.Authentication.current_admin(info),
         {:ok, hospital_manager} <- Context.HospitalManager.create(params) do
      {:ok, %{hospital_manager: hospital_manager}}
    end
  end
end
