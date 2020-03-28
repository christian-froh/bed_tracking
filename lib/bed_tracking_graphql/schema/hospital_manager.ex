defmodule BedTrackingGraphql.Schema.HospitalManager do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :hospital_manager do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
    field(:name, non_null(:string))
  end

  ### PAYLOADS ###
  object :create_hospital_manager_payload do
    field(:hospital_manager, non_null(:hospital_manager))
  end

  ### INPUTS ###
  input_object :create_hospital_manager_input do
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field(:password, non_null(:string))
    field(:hospital_id, non_null(:id))
  end

  ### QUERIES ###
  # object :admin_queries do
  #   field :current_admin, type: :current_admin_payload do
  #     resolve(&Resolver.Admin.get_current/2)
  #   end
  # end

  ### MUTATIONS ###
  object :hospital_manager_mutations do
    field :create_hospital_manager, type: :create_hospital_manager_payload do
      arg(:input, non_null(:create_hospital_manager_input))
      resolve(&Resolver.HospitalManager.create/2)
    end
  end
end
