defmodule BedTrackingGraphql.Resolver.Admin do
  use BedTrackingGraphql.Resolver.Base
  alias BedTracking.Context

  def get_current(_params, info) do
    with {:ok, current_admin} <- Context.Authentication.current_admin(info) do
      {:ok, %{admin: current_admin}}
    end
  end

  def login(%{input: %{email: email, password: password}}, _info) do
    with {:ok, token} <- Context.Admin.login(email, password) do
      {:ok, %{token: token}}
    end
  end
end
