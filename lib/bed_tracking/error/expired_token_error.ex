defmodule BedTracking.Error.ExpiredTokenError do
  use ExErrors

  @enforce_keys [:token]
  defstruct [
    :token,
    message: "Expired token",
    __typename: "ExpiredTokenError"
  ]
end
