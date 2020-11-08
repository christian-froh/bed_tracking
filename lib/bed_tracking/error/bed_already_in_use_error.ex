defmodule BedTracking.Error.BedAlreadyInUseError do
  use ExErrors

  @enforce_keys [:bed_id]
  defstruct [
    :bed_id,
    message: "Bed already in use",
    error_code: "BedAlreadyInUseError"
  ]
end
