defmodule BedTrackingGraphql.Schema.Admin do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :admin do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
    field(:name, non_null(:string))
  end

  ### PAYLOADS ###
  object :current_admin_payload do
    field(:admin, non_null(:admin))
  end

  object :login_payload do
    field(:token, non_null(:string))
  end

  ### INPUTS ###
  input_object :login_input do
    field(:email, non_null(:string))
    field(:password, non_null(:string))
  end

  ### QUERIES ###
  object :admin_queries do
    field :current_admin, type: :current_admin_payload do
      resolve(&Resolver.Admin.get_current/2)
    end
  end

  ### MUTATIONS ###
  object :admin_mutations do
    field :login, type: :login_payload do
      arg(:input, non_null(:login_input))
      resolve(&Resolver.Admin.login/2)
    end
  end
end
