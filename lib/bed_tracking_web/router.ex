defmodule BedTrackingWeb.Router do
  use BedTrackingWeb, :router

  pipeline :graphql_api do
    plug :accepts, ["json"]

    plug(BedTrackingWeb.Plugs.GraphqlContext)
  end

  scope "/api" do
    pipe_through :graphql_api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BedTrackingGraphql.Schema,
      pipeline: {ApolloTracing.Pipeline, :plug}

    forward "/", Absinthe.Plug,
      schema: BedTrackingGraphql.Schema,
      pipeline: {ApolloTracing.Pipeline, :plug}
  end
end
