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

  object :get_bed_payload do
    field :bed, :bed
  end

  object :update_bed_availability_payload do
    field :bed, :bed
  end

  ### INPUTS ###
  input_object :register_bed_input do
    field(:hospital_id, non_null(:id))
  end

  input_object :get_bed_input do
    field(:id, non_null(:id))
  end

  input_object :update_bed_availability_input do
    field(:id, non_null(:id))
    field(:available, non_null(:boolean))
  end

  ### QUERIES ###
  object :bed_queries do
    field :get_bed, :get_bed_payload do
      arg(:input, non_null(:get_bed_input))
      resolve(&Resolver.Bed.get/2)
    end
  end

  ### MUTATIONS ###
  object :bed_mutations do
    field :register_bed, type: :register_bed_payload do
      arg(:input, non_null(:register_bed_input))
      resolve(&Resolver.Bed.register/2)
    end

    field :update_bed_availability, type: :update_bed_availability_payload do
      arg(:input, non_null(:update_bed_availability_input))
      resolve(&Resolver.Bed.update_availability/2)
    end
  end
end
