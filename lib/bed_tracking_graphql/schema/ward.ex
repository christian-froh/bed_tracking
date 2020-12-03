defmodule BedTrackingGraphql.Schema.Ward do
  use BedTrackingGraphql.Schema.Base
  alias BedTracking.Context
  alias BedTracking.Repo

  ### ENUMS ###
  enum :ward_type do
    value(:amber, as: "amber")
    value(:green, as: "green")
    value(:covid, as: "covid")
  end

  ### OBJECTS ###
  object :ward do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:description, :string)
    field(:ward_type, non_null(:ward_type))
    field(:is_surge_ward, :boolean)
    field(:number_of_critcare_nurses, :integer)
    field(:number_of_other_rns, :integer)
    field(:number_of_nurse_support_staff, :integer)
    field(:max_admission_capacity, :integer)
    field(:can_provide_ics_ratios, :boolean)

    field :last_updated_at_of_ward_or_beds, :datetime do
      resolve(&Resolver.Ward.dataloader_last_updated_at_of_ward_or_beds/3)
    end

    field :last_updated_by_hospital_manager_of_ward_or_beds, :hospital_manager do
      resolve(&Resolver.Ward.dataloader_last_updated_by_hospital_manager_of_ward_or_beds/3)
    end

    field :total_beds, :integer do
      resolve(&Resolver.Ward.dataloader_total_beds/3)
    end

    field :available_beds, :integer do
      resolve(&Resolver.Ward.dataloader_available_beds/3)
    end

    field :unavailable_beds, :integer do
      resolve(&Resolver.Ward.dataloader_unavailable_beds/3)
    end

    field :total_covid_status_unknown_suspected, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_covid_status(hospital, params, info, "unknown_suspected") end)
    end

    field :total_covid_status_unknown_not_suspected, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_covid_status(hospital, params, info, "unknown_not_suspected") end)
    end

    field :total_covid_status_negative, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_covid_status(hospital, params, info, "negative") end)
    end

    field :total_covid_status_positive, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_covid_status(hospital, params, info, "positive") end)
    end

    field :total_covid_status_green, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_covid_status(hospital, params, info, "green") end)
    end

    field :total_level_of_care_level_one, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_level_of_care(hospital, params, info, "level_1") end)
    end

    field :total_level_of_care_level_two, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_level_of_care(hospital, params, info, "level_2") end)
    end

    field :total_level_of_care_level_three, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_level_of_care(hospital, params, info, "level_3") end)
    end

    field :total_rrt_type_none, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_rrt_type(hospital, params, info, "none") end)
    end

    field :total_rrt_type_risk_of_next_twenty_four_h, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_rrt_type(hospital, params, info, "risk_of_next_twenty_four_h") end)
    end

    field :total_rrt_type_haemodialysis, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_rrt_type(hospital, params, info, "haemodialysis") end)
    end

    field :total_rrt_type_haemofiltration, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_rrt_type(hospital, params, info, "haemofiltration") end)
    end

    field :total_rrt_type_pd, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_rrt_type(hospital, params, info, "pd") end)
    end

    field :total_ventilation_type_none, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_ventilation_type(hospital, params, info, "none") end)
    end

    field :total_ventilation_type_sv, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_ventilation_type(hospital, params, info, "sv") end)
    end

    field :total_ventilation_type_nasal, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_ventilation_type(hospital, params, info, "nasal") end)
    end

    field :total_ventilation_type_cpap, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_ventilation_type(hospital, params, info, "cpap") end)
    end

    field :total_ventilation_type_hfno, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_ventilation_type(hospital, params, info, "hfno") end)
    end

    field :total_ventilation_type_bipap, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_ventilation_type(hospital, params, info, "bipap") end)
    end

    field :total_ventilation_type_invasive, :integer do
      resolve(fn hospital, params, info -> Resolver.Ward.dataloader_total_ventilation_type(hospital, params, info, "invasive") end)
    end

    field :beds, list_of(:bed) do
      resolve(
        dataloader(Repo, :beds,
          args: %{
            query_fun: fn query ->
              Context.Bed.Query.ordered_by(query, :asc, :inserted_at)
            end
          }
        )
      )
    end

    field :hospital, non_null(:hospital) do
      resolve(dataloader(Repo))
    end
  end

  ### PAYLOADS ###
  object :create_ward_payload do
    field :ward, :ward
  end

  object :update_ward_payload do
    field :ward, :ward
  end

  object :remove_ward_payload do
    field :success, :boolean
  end

  ### INPUTS ###
  input_object :create_ward_input do
    field(:name, non_null(:string))
    field(:description, :string)
    field(:ward_type, non_null(:ward_type))
    field(:is_surge_ward, :boolean)
    field(:number_of_critcare_nurses, :integer)
    field(:number_of_other_rns, :integer)
    field(:number_of_nurse_support_staff, :integer)
    field(:max_admission_capacity, :integer)
    field(:can_provide_ics_ratios, :boolean)
  end

  input_object :update_ward_input do
    field(:id, non_null(:id))
    field(:name, :string)
    field(:description, :string)
    field(:ward_type, :ward_type)
    field(:is_surge_ward, :boolean)
    field(:number_of_critcare_nurses, :integer)
    field(:number_of_other_rns, :integer)
    field(:number_of_nurse_support_staff, :integer)
    field(:max_admission_capacity, :integer)
    field(:can_provide_ics_ratios, :boolean)
  end

  input_object :remove_ward_input do
    field(:id, non_null(:id))
  end

  ### MUTATIONS ###
  object :ward_mutations do
    field :create_ward, type: :create_ward_payload do
      arg(:input, non_null(:create_ward_input))
      resolve(&Resolver.Ward.create/2)
    end

    field :update_ward, type: :update_ward_payload do
      arg(:input, non_null(:update_ward_input))
      resolve(&Resolver.Ward.update/2)
    end

    field :remove_ward, type: :remove_ward_payload do
      arg(:input, non_null(:remove_ward_input))
      resolve(&Resolver.Ward.remove/2)
    end
  end
end
