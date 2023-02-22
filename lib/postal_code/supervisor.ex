defmodule ElhexDelivery.PostalCode.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do
    args[:conf] |> IO.inspect()
    children = [
      {ElhexDelivery.PostalCode.Store, conf: args[:conf], name: {:via, ElhexDelivery.PostalCode.Store, __MODULE__}},
      # {ElhexDelivery.PostalCode.Navigator, args},
      # {ElhexDelivery.PostalCode.Cache, args}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
