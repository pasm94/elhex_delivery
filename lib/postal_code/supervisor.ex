defmodule ElhexDelivery.PostalCode.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      {ElhexDelivery.PostalCode.Store, []},
      {ElhexDelivery.PostalCode.Navigator, []},
      {ElhexDelivery.PostalCode.Cache, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
