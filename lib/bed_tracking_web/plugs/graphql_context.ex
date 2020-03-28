defmodule BedTrackingWeb.Plugs.GraphqlContext do
  @behaviour Plug

  @spec init(opts :: term) :: binary()
  def init(opts), do: opts

  @spec call(conn :: Plug.Conn.t(), info :: term) :: Plug.Conn.t()
  def call(conn, _) do
    context = BedTrackingWeb.Plugs.Context.call(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end
end
