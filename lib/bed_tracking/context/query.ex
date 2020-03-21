defmodule BedTracking.Context.Query do
  defmacro __using__(_args) do
    quote do
      import Ecto.Query

      @spec where_id(query :: term, id :: nil | String.t()) :: %Ecto.Query{}
      def where_id(query, nil), do: query

      def where_id(query, id) when is_binary(id) do
        from row in query,
          where: row.id == ^id
      end

      @spec where_ids(query :: term, ids :: [String.t()]) :: %Ecto.Query{}
      def where_ids(query, ids) when is_list(ids) do
        from row in query,
          where: row.id in ^ids
      end

      @spec paginate(query :: term, params :: map) :: %Ecto.Query{}
      def paginate(query, params) do
        params = ensure_limit_offset(params)

        from d in query,
          limit: ^params[:limit],
          offset: ^params[:offset]
      end

      defp ensure_limit_offset(params, default_limit \\ 10, default_offset \\ 0) do
        limit = params[:limit] || default_limit
        offset = params[:offset] || default_offset

        params
        |> Map.merge(%{limit: limit, offset: offset})
      end
    end
  end
end
