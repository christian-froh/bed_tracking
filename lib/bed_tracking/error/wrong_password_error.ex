defmodule BedTracking.Error.WrongPasswordError do
  use ExErrors

  defstruct message: "Wrong password",
            error_code: "WrongPasswordError"
end
