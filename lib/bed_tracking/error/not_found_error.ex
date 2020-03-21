defmodule BedTracking.Error.NotFoundError do
  use ExErrors

  @enforce_keys [:fields, :type]
  defstruct [
    :fields,
    :type,
    message: "No object found with the given fields",
    error_code: "NotFoundError"
  ]
end
