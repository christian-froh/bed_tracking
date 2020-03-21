defmodule BedTrackingGraphql.Resolver.Error do
  def get_errors(_params, _info) do
    errors = ExErrors.list_error_specs(:bed_tracking)

    {:ok, %{errors: errors}}
  end
end
