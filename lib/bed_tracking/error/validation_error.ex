defmodule BedTracking.Error.ValidationError do
  use ExErrors

  @enforce_keys [:field, :reason]
  defstruct [
    :field,
    :reason,
    :details,
    message: "Invalid parameter",
    error_code: "ValidationError"
  ]
end
