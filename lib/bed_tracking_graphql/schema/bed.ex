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

  ### PAYLOADS ###
  object :register_bed_payload do
    field :bed, :bed
  end

  ### INPUTS ###
  input_object :register_bed_input do
    field(:hospital_id, :id)
  end

  ### MUTATIONS ###
  object :bed_mutations do
    field :register_bed, type: :register_bed_payload do
      arg(:input, non_null(:register_bed_input))
      resolve(&Resolver.Bed.register/2)
    end
  end
end
