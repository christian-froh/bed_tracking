defmodule BedTrackingGraphql.Resolver.Ward do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def create(%{input: %{name: name}}, info) do
    with {:ok, current_hospital} <- Context.Authentication.current_hospital(info),
         {:ok, ward} <- Context.Ward.create(name, current_hospital.id) do
      {:ok, %{ward: ward}}
    end
  end
end
