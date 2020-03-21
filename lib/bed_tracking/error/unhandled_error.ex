defmodule BedTracking.Error.UnhandledError do
  use ExErrors

  @enforce_keys [:unhandled_error]
  defstruct [
    :unhandled_error,
    message: "Something went wrong",
    error_code: "UnhandledError"
  ]
end
