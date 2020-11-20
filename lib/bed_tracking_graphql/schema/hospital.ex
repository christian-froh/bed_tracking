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

    field :total_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_total_beds/3)
    end

    field :available_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_available_beds/3)
    end

    field :unavailable_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_unavailable_beds/3)
    end

    field :total_amber_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_total_amber_beds/3)
    end

    field :total_available_amber_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_total_available_amber_beds/3)
    end

    field :total_green_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_total_green_beds/3)
    end

    field :total_available_green_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_total_available_green_beds/3)
    end

    field :total_covid_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_total_covid_beds/3)
    end

    field :total_available_covid_beds, :integer do
      resolve(&Resolver.Hospital.dataloader_total_available_covid_beds/3)
    end

    field :total_covid_status_suspected, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_covid_status(hospital, params, info, "suspected") end)
    end

    field :total_covid_status_negative, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_covid_status(hospital, params, info, "negative") end)
    end

    field :total_covid_status_positive, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_covid_status(hospital, params, info, "positive") end)
    end

    field :total_covid_status_green, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_covid_status(hospital, params, info, "green") end)
    end

    field :total_level_of_care_level_one, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_level_of_care(hospital, params, info, "level_1") end)
    end

    field :total_level_of_care_level_two, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_level_of_care(hospital, params, info, "level_2") end)
    end

    field :total_level_of_care_level_three, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_level_of_care(hospital, params, info, "level_3") end)
    end

    field :total_rrt_type_none, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_rrt_type(hospital, params, info, "none") end)
    end

    field :total_rrt_type_risk_of_next_twenty_four_h, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_rrt_type(hospital, params, info, "risk_of_next_twenty_four_h") end)
    end

    field :total_rrt_type_haemodialysis, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_rrt_type(hospital, params, info, "haemodialysis") end)
    end

    field :total_rrt_type_haemofiltration, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_rrt_type(hospital, params, info, "haemofiltration") end)
    end

    field :total_rrt_type_pd, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_rrt_type(hospital, params, info, "pd") end)
    end

    field :total_ventilation_type_none, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_ventilation_type(hospital, params, info, "none") end)
    end

    field :total_ventilation_type_sv, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_ventilation_type(hospital, params, info, "sv") end)
    end

    field :total_ventilation_type_nasal, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_ventilation_type(hospital, params, info, "nasal") end)
    end

    field :total_ventilation_type_cpap, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_ventilation_type(hospital, params, info, "cpap") end)
    end

    field :total_ventilation_type_hfno, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_ventilation_type(hospital, params, info, "hfno") end)
    end

    field :total_ventilation_type_bipap, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_ventilation_type(hospital, params, info, "bipap") end)
    end

    field :total_ventilation_type_invasive, :integer do
      resolve(fn hospital, params, info -> Resolver.Hospital.dataloader_total_ventilation_type(hospital, params, info, "invasive") end)
    end

    field :total_number_of_critcare_nurses, :integer do
      resolve(&Resolver.Hospital.dataloader_total_number_of_critcare_nurses/3)
    end

    field :total_number_of_other_rns, :integer do
      resolve(&Resolver.Hospital.dataloader_total_number_of_other_rns/3)
    end

    field :total_number_of_nurse_support_staff, :integer do
      resolve(&Resolver.Hospital.dataloader_total_number_of_nurse_support_staff/3)
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

  ### INPUTS ###
  input_object :create_hospital_input do
    field(:name, non_null(:string))
    field(:latitude, non_null(:float))
    field(:longitude, non_null(:float))
    field(:address, :string)
  end

  ### QUERIES ###
  object :hospital_queries do
    field :get_hospital, :get_hospital_payload do
      resolve(&Resolver.Hospital.get_hospital/2)
    end
  end
end
