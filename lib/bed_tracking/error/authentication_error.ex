defmodule BedTracking.Error.AuthenticationError do
  use ExErrors

  @enforce_keys []
  defstruct message: "Authentication failed",
            error_code: "AuthenticationError"
end
