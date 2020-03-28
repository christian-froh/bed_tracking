defmodule BedTracking.Context.Admin.Query do
  use BedTracking.Context.Query

  def where_email(query, email) when is_binary(email) do
    from a in query,
      where: a.email == ^email
  end
end
