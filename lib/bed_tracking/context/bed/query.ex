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

  def where_available(query) do
    from b in query,
      where: b.available == true
  end

  def where_not_available(query) do
    from b in query,
      where: b.available == false
  end

  def where_ventilator_in_use(query) do
    from b in query,
      where: b.ventilator_in_use == true
  end

  def where_covid_status(query, status) do
    from b in query,
      where: b.covid_status == ^status
  end

  def where_level_of_care(query, level) do
    from b in query,
      where: b.level_of_care == ^level
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
