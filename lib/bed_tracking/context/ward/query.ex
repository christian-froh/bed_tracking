defmodule BedTracking.Context.Ward.Query do
  use BedTracking.Context.Query

  def where_hospital_id(query, nil), do: query

  def where_hospital_id(query, id) when is_binary(id) do
    from w in query,
      where: w.hospital_id == ^id
  end

  def ordered_by(query, order, field) do
    from w in query,
      order_by: [{^order, field(w, ^field)}]
  end

  def total_beds(query) do
    from w in query,
      select: sum(w.total_beds)
  end

  def available_beds(query) do
    from w in query,
      select: sum(w.available_beds)
  end

  def unavailable_beds(query) do
    from w in query,
      select: sum(w.total_beds) - sum(w.available_beds)
  end
end
