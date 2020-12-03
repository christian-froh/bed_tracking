defmodule BedTracking.Context.HospitalManager.Query do
  use BedTracking.Context.Query

  def where_username(query, username) when is_binary(username) do
    from hm in query,
      where: hm.username == ^username
  end

  def with_hospital(query) do
    from hm in query,
      preload: [:hospital]
  end
end
