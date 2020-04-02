defmodule BedTracking.Context.Bed.Query do
  use BedTracking.Context.Query

  def where_hospital_id(query, nil), do: query

  def where_hospital_id(query, id) when is_binary(id) do
    from b in query,
      where: b.hospital_id == ^id
  end

  def where_ward_id(query, nil), do: query

  def where_ward_id(query, id) when is_binary(id) do
    from b in query,
      where: b.ward_id == ^id
  end

  def where_active(query) do
    from b in query,
      where: b.active == true
  end

  def where_available(query) do
    from b in query,
      where: b.available == true
  end

  def where_not_available(query) do
    from b in query,
      where: b.available == false
  end

  def ordered_by(query, order, field) do
    from b in query,
      order_by: [{^order, field(b, ^field)}]
  end

  def count(query) do
    from b in query,
      select: count(b.id)
  end
end
