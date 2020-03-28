defmodule BedTracking.Error.ExpiredTokenError do
  use ExErrors

  @enforce_keys [:token]
  defstruct [
    :token,
    message: "Expired token",
    error_code: "ExpiredTokenError"
  ]
end
