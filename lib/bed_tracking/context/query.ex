defmodule BedTracking.Context.Query do
  defmacro __using__(_args) do
    quote do
      import Ecto.Query

      def where_id(query, nil), do: query

      def where_id(query, id) when is_binary(id) do
        from row in query,
          where: row.id == ^id
      end

      def where_ids(query, ids) when is_list(ids) do
        from row in query,
          where: row.id in ^ids
      end
    end
  end
end
