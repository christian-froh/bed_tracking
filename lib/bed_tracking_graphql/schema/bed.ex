defmodule BedTrackingGraphql.Schema.Bed do
  use BedTrackingGraphql.Schema.Base

  ### ENUMS ###
  enum :covid_status do
    value(:suspected, as: "suspected")
    value(:negative, as: "negative")
    value(:positive, as: "positive")
    value(:green, as: "green")
  end

  enum :level_of_care do
    value(:level_1, as: "level_1")
    value(:level_2, as: "level_2")
    value(:level_3, as: "level_3")
  end

  enum :ventilation_type do
    value(:none, as: "none")
    value(:sv, as: "sv")
    value(:nasal, as: "nasal")
    value(:crap, as: "crap")
    value(:hfno, as: "hfno")
    value(:bipap, as: "bipap")
    value(:invasive, as: "invasive")
  end

  enum :sex do
    value(:male, as: "male")
    value(:female, as: "female")
  end

  enum :source_of_admission do
    value(:ed, as: "ed")
    value(:internal_ward, as: "internal_ward")
    value(:internal_itu, as: "internal_itu")
    value(:external_ward, as: "external_ward")
    value(:external_itu, as: "external_itu")
  end

  enum :rtt_type do
    value(:none, as: "none")
    value(:risk_of_next_twenty_four_h, as: "risk_of_next_twenty_four_h")
    value(:haemodialysis, as: "haemodialysis")
    value(:haemofiltration, as: "haemofiltration")
    value(:pd, as: "pd")
  end

  enum :discharge_reason do
    value(:internal_ward, as: "internal_ward")
    value(:internal_icu, as: "internal_icu")
    value(:external_ward, as: "external_ward")
    value(:external_icu, as: "external_icu")
    value(:death, as: "death")
    value(:other, as: "other")
  end

  ### OBJECTS ###
  object :bed do
    field(:id, non_null(:id))
    field(:available, non_null(:boolean))
    field(:covid_status, :covid_status)
    field(:level_of_care, :level_of_care)
    field(:ventilation_type, :ventilation_type)
    field(:reference, :string)
    field(:initials, :string)
    field(:sex, :sex)
    field(:date_of_admission, :datetime)
    field(:source_of_admission, :source_of_admission)
    field(:use_tracheostomy, :boolean)
    field(:rtt_type, :rtt_type)

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

  object :discharge_patient_payload do
    field :success, :boolean
  end

  ### INPUTS ###
  input_object :register_beds_input do
    field(:number_of_beds, non_null(:integer))
    field(:ward_id, non_null(:id))
    field(:prefix, :string)
    field(:start_from, :integer)
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
    field(:covid_status, :covid_status)
    field(:level_of_care, :level_of_care)
    field(:ventilation_type, :ventilation_type)
    field(:reference, :string)
    field(:initials, :string)
    field(:sex, :sex)
    field(:date_of_admission, :datetime)
    field(:source_of_admission, :source_of_admission)
    field(:rtt_type, :rtt_type)
    field(:use_tracheostomy, :boolean)
  end

  input_object :discharge_patient_input do
    field(:id, non_null(:id))
    field(:reason, non_null(:discharge_reason))
    field(:bed_id, :id)
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

    field :discharge_patient, type: :discharge_patient_payload do
      arg(:input, non_null(:discharge_patient_input))
      resolve(&Resolver.Bed.discharge_patient/2)
    end
  end
end
