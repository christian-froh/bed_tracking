defmodule BedTrackingGraphql.Schema.HospitalManager do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :hospital_manager do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
    field(:firstname, non_null(:string))
    field(:lastname, non_null(:string))
    field(:phone_number, :string)

    field :hospital, non_null(:hospital) do
      resolve(dataloader(Repo))
    end
  end

  ### PAYLOADS ###
  object :create_hospital_manager_payload do
    field(:hospital_manager, non_null(:hospital_manager))
  end

  object :update_hospital_manager_payload do
    field(:hospital_manager, non_null(:hospital_manager))
  end

  object :login_hospital_manager_payload do
    field(:hospital_manager, non_null(:hospital_manager))
  end

  ### INPUTS ###
  input_object :create_hospital_manager_input do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
    field(:firstname, non_null(:string))
    field(:lastname, non_null(:string))
    field(:phone_number, :string)
    field(:hospital_id, non_null(:id))
  end

  input_object :update_hospital_manager_input do
    field(:id, non_null(:id))
    field(:firstname, :string)
    field(:lastname, :string)
    field(:phone_number, :string)
  end

  input_object :login_hospital_manager_input do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  ### MUTATIONS ###
  object :hospital_manager_mutations do
    field :create_hospital_manager, type: :create_hospital_manager_payload do
      arg(:input, non_null(:create_hospital_manager_input))
      resolve(&Resolver.HospitalManager.create/2)
    end

    field :update_hospital_manager, type: :update_hospital_manager_payload do
      arg(:input, non_null(:update_hospital_manager_input))
      resolve(&Resolver.HospitalManager.update/2)
    end

    field :login_hospital_manager, type: :login_hospital_manager_payload do
      arg(:input, non_null(:login_hospital_manager_input))
      resolve(&Resolver.HospitalManager.login/2)
    end
  end
end
