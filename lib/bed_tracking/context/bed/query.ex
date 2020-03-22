defmodule BedTracking.Context.Bed.Query do
  use BedTracking.Context.Query

  def where_hospital_id(query, nil), do: query

  def where_hospital_id(query, id) when is_binary(id) do
    from b in query,
      where: b.hospital_id == ^id
  end

  def where_available(query) do
    from b in query,
      where: b.available == true
  end

  def count(query) do
    from b in query,
      select: count(b.id)
  end
end
