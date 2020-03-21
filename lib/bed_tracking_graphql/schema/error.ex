defmodule BedTrackingGraphql.Schema.Error do
  use BedTrackingGraphql.Schema.Base

  ### OBJECTS ###
  object :error do
    field(:error_code, non_null(:string))
    field(:fields, non_null(list_of(:string)))
    field(:required_fields, non_null(list_of(:string)))
  end

  ### PAYLOADS ###
  object :get_errors_payload do
    field(:errors, list_of(:error))
  end

  ### QUERIES ###
  object :error_queries do
    field :get_errors, :get_errors_payload do
      resolve(&Resolver.Error.get_errors/2)
    end
  end
end
