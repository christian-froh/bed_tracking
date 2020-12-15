defmodule BedTracking.Error.UsernameAlreadyInUseError do
  use ExErrors

  defstruct message: "Username already in use",
            error_code: "UsernameAlreadyInUseError"
end
