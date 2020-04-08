defmodule BedTracking.Context.Hospital.Query do
  use BedTracking.Context.Query

  def ordered_by(query, order, field) do
    from b in query,
      order_by: [{^order, field(b, ^field)}]
  end
end
