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

      def ordered_by(query, order, field) do
        from row in query,
          order_by: [{^order, field(row, ^field)}]
      end

      def limit(query, limit) do
        from row in query,
          limit: ^limit
      end
    end
  end
end
