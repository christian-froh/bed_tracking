defmodule BedTracking.Error.AuthenticationError do
  use ExErrors

  @enforce_keys []
  defstruct message: "Authentication failed",
            __typename: "AuthenticationError"
end
