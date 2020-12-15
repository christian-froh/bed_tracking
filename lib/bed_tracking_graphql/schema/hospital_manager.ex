defmodule BedTrackingGraphql.Schema.HospitalManager do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :hospital_manager do
    field(:id, non_null(:id))
    field(:username, non_null(:string))
    field(:firstname, non_null(:string))
    field(:lastname, non_null(:string))
    field(:phone_number, :string)
    field(:is_admin, :boolean)
    field(:last_login_at, :datetime)

    field :hospital, non_null(:hospital) do
      resolve(dataloader(Repo))
    end
  end

  ### PAYLOADS ###
  object :current_hospital_manager_payload do
    field(:hospital_manager, non_null(:hospital_manager))
  end

  object :create_hospital_manager_payload do
    field(:hospital_manager, non_null(:hospital_manager))
  end

  object :update_hospital_manager_payload do
    field(:hospital_manager, non_null(:hospital_manager))
  end

  object :login_hospital_manager_payload do
    field(:token, non_null(:string))
    field(:is_changed_password, non_null(:boolean))
  end

  object :change_password_payload do
    field(:token, non_null(:string))
  end

  object :reset_password_payload do
    field(:success, non_null(:boolean))
  end

  ### INPUTS ###
  input_object :create_hospital_manager_input do
    field(:username, non_null(:string))
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
    field(:username, non_null(:string))
    field(:password, non_null(:string))
  end

  input_object :change_password_input do
    field(:old_password, non_null(:string))
    field(:new_password, non_null(:string))
  end

  input_object :reset_password_input do
    field(:hospital_manager_id, non_null(:id))
    field(:new_password, non_null(:string))
  end

  ### QUERIES ###
  object :hospital_manager_queries do
    field :current_hospital_manager, type: :current_hospital_manager_payload do
      resolve(&Resolver.HospitalManager.get_current/2)
    end
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

    field :change_password, type: :change_password_payload do
      arg(:input, non_null(:change_password_input))
      resolve(&Resolver.HospitalManager.change_password/2)
    end

    field :reset_password, type: :reset_password_payload do
      arg(:input, non_null(:reset_password_input))
      resolve(&Resolver.HospitalManager.reset_password/2)
    end
  end
end
