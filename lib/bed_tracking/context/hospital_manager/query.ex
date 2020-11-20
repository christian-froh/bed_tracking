defmodule BedTracking.Context.HospitalManager.Query do
  use BedTracking.Context.Query

  def where_email(query, email) when is_binary(email) do
    from hm in query,
      where: hm.email == ^email
  end

  def with_hospital(query) do
    from hm in query,
      preload: [:hospital]
  end
end
