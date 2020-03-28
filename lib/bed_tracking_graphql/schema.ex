defmodule BedTrackingGraphql.Schema do
  use Absinthe.Schema
  alias BedTracking.Repo

  require Logger

  import_types(Absinthe.Plug.Types)
  import_types(Absinthe.Type.Custom)
  import_types(BedTrackingGraphql.Schema.Error)
  import_types(BedTrackingGraphql.Schema.Admin)
  import_types(BedTrackingGraphql.Schema.Hospital)
  import_types(BedTrackingGraphql.Schema.Bed)
  import_types(BedTrackingGraphql.Schema.Facility)

  query do
    import_fields(:admin_queries)
    import_fields(:bed_queries)
    import_fields(:error_queries)
    import_fields(:hospital_queries)
  end

  mutation do
    import_fields(:admin_mutations)
    import_fields(:bed_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Repo, Dataloader.Ecto.new(Repo, query: &dataloader_query/2))

    Map.put(ctx, :loader, loader)
  end

  def middleware(middleware, _field, _object) do
    middleware ++
      [
        BedTrackingGraphql.Middlewares.ErrorHandler,
        ApolloTracing.Middleware.Tracing,
        ApolloTracing.Middleware.Caching
      ]
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  # Query function for dataloader calls of the repo
  # When loading objects we can specify filters by using our own query function.
  # https://hexdocs.pm/dataloader/Dataloader.Ecto.html#module-filtering-ordering
  defp dataloader_query(query, params) do
    case params[:query_fun] do
      nil ->
        query

      query_fun when is_function(query_fun, 1) ->
        query_fun.(query)

      {query_fun, args} when is_function(query_fun, 2) ->
        query_fun.(query, args)

      not_implemented ->
        Logger.warn(
          "Dataloader query not implemented for query function #{inspect(not_implemented)}"
        )

        query
    end
  end
end
