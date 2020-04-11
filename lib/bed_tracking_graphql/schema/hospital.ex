defmodule BedTrackingGraphql.Schema.Hospital do
  use BedTrackingGraphql.Schema.Base
  alias BedTracking.Context
  alias BedTracking.Repo

  ### OBJECTS ###
  object :hospital do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:latitude, non_null(:float))
    field(:longitude, non_null(:float))
    field(:address, :string)
    field(:use_management, :boolean)

    field :total_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_total_beds/3)
    end

    field :available_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_available_beds/3)
    end

    field :unavailable_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_unavailable_beds/3)
    end

    field :total_covid_status_suspected, :integer do
      resolve(&Resolver.Hospital.dataloader_total_covid_status_suspected/3)
    end

    field :total_covid_status_negative, :integer do
      resolve(&Resolver.Hospital.dataloader_total_covid_status_negative/3)
    end

    field :total_covid_status_positive, :integer do
      resolve(&Resolver.Hospital.dataloader_total_covid_status_positive/3)
    end

    field :total_level_of_care_level_one, :integer do
      resolve(&Resolver.Hospital.dataloader_total_level_of_care_level_1/3)
    end

    field :total_level_of_care_level_two, :integer do
      resolve(&Resolver.Hospital.dataloader_total_level_of_care_level_2/3)
    end

    field :total_level_of_care_level_three, :integer do
      resolve(&Resolver.Hospital.dataloader_total_level_of_care_level_3/3)
    end

    field :total_ventilation_type_sv, :integer do
      resolve(&Resolver.Hospital.dataloader_total_ventilation_type_sv/3)
    end

    field :total_ventilation_type_niv, :integer do
      resolve(&Resolver.Hospital.dataloader_total_ventilation_type_niv/3)
    end

    field :total_ventilation_type_intubated, :integer do
      resolve(&Resolver.Hospital.dataloader_total_ventilation_type_intubated/3)
    end

    field :total_ventilator_in_use, :integer do
      resolve(&Resolver.Hospital.dataloader_total_ventilator_in_use/3)
    end

    field :available_hemofilter, :integer do
      resolve(&Resolver.Hospital.dataloader_available_hemofilter/3)
    end

    field :wards, list_of(:ward) do
      resolve(
        dataloader(Repo, :wards,
          args: %{
            query_fun: fn query ->
              Context.Ward.Query.ordered_by(query, :asc, :name)
            end
          }
        )
      )
    end

    field :hospital_managers, list_of(:hospital_manager) do
      resolve(dataloader(Repo))
    end
  end

  ### PAYLOADS ###
  object :get_hospitals_payload do
    field :hospitals, list_of(:hospital)
  end

  object :get_hospital_payload do
    field :hospital, :hospital
  end

  object :create_hospital_payload do
    field :hospital, :hospital
  end

  object :use_management_system_payload do
    field :hospital, :hospital
  end

  ### INPUTS ###
  input_object :create_hospital_input do
    field(:name, non_null(:string))
    field(:latitude, non_null(:float))
    field(:longitude, non_null(:float))
    field(:address, :string)
  end

  input_object :use_management_system_input do
    field(:use_management, non_null(:boolean))
  end

  ### QUERIES ###
  object :hospital_queries do
    field :get_hospitals, :get_hospitals_payload do
      resolve(&Resolver.Hospital.get_hospitals/2)
    end

    field :get_hospital, :get_hospital_payload do
      resolve(&Resolver.Hospital.get_hospital/2)
    end
  end

  ### MUTATIONS ###
  object :hospital_mutations do
    field :create_hospital, type: :create_hospital_payload do
      arg(:input, non_null(:create_hospital_input))
      resolve(&Resolver.Hospital.create_hospital/2)
    end

    field :use_management_system, type: :use_management_system_payload do
      arg(:input, non_null(:use_management_system_input))
      resolve(&Resolver.Hospital.use_management_system/2)
    end
  end
end
