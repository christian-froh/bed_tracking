defmodule BedTracking.Context.Ward.Query do
  use BedTracking.Context.Query

  def ordered_by(query, order, field) do
    from w in query,
      order_by: [{^order, field(w, ^field)}]
  end
end
