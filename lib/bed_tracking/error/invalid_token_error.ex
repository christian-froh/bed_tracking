defmodule BedTracking.Error.InvalidTokenError do
  use ExErrors

  @enforce_keys [:token]
  defstruct [
    :token,
    message: "Invalid token",
    error_code: "InvalidTokenError"
  ]
end
