defmodule BedTrackingGraphql.Schema.Bed do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :bed do
    field(:id, non_null(:id))
    field(:available, non_null(:boolean))

    field :hospital, non_null(:hospital) do
      resolve(dataloader(Repo))
    end
  end
end
