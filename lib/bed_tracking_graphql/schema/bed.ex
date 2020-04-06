defmodule BedTrackingGraphql.Schema.Bed do
  use BedTrackingGraphql.Schema.Base

  ### ENUMS ###
  enum :covid_status do
    value(:suspected, as: "suspected")
    value(:negative, as: "negative")
    value(:positive, as: "positive")
  end

  ### OBJECTS ###
  object :bed do
    field(:id, non_null(:id))
    field(:available, non_null(:boolean))
    field(:ventilator_in_use, :boolean)
    field(:covid_status, :covid_status)

    field :ward, non_null(:ward) do
      resolve(dataloader(Repo))
    end

    field :hospital, non_null(:hospital) do
      resolve(dataloader(Repo))
    end
  end

  ### PAYLOADS ###
  object :register_beds_payload do
    field :beds, list_of(:bed)
  end

  object :register_bed_payload do
    field :bed, :bed
  end

  object :remove_bed_payload do
    field :success, :boolean
  end

  object :get_bed_payload do
    field :bed, :bed
  end

  object :update_bed_payload do
    field :bed, :bed
  end

  ### INPUTS ###
  input_object :register_beds_input do
    field(:number_of_beds, non_null(:integer))
    field(:ward_id, non_null(:id))
  end

  input_object :register_bed_input do
    field(:ward_id, non_null(:id))
  end

  input_object :remove_bed_input do
    field(:id, non_null(:id))
  end

  input_object :get_bed_input do
    field(:id, non_null(:id))
  end

  input_object :update_bed_input do
    field(:id, non_null(:id))
    field(:available, :boolean)
    field(:ventilator_in_use, :boolean)
    field(:covid_status, :covid_status)
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
    field :register_beds, type: :register_beds_payload do
      arg(:input, non_null(:register_beds_input))
      resolve(&Resolver.Bed.register_multiple/2)
    end

    field :register_bed, type: :register_bed_payload do
      arg(:input, non_null(:register_bed_input))
      resolve(&Resolver.Bed.register/2)
    end

    field :remove_bed, type: :remove_bed_payload do
      arg(:input, non_null(:remove_bed_input))
      resolve(&Resolver.Bed.remove/2)
    end

    field :update_bed, type: :update_bed_payload do
      arg(:input, non_null(:update_bed_input))
      resolve(&Resolver.Bed.update/2)
    end
  end
end
