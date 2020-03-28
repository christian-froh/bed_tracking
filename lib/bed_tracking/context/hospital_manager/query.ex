defmodule BedTracking.Context.HospitalManager.Query do
  use BedTracking.Context.Query

  def where_email(query, email) when is_binary(email) do
    from hm in query,
      where: hm.email == ^email
  end
end
