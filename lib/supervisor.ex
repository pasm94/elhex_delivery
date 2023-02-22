defmodule ElhexDelivery.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do
    children = [
      {ElhexDelivery.PostalCode.Supervisor, conf: args[:conf], name: {:via, ElhexDelivery.PostalCode.Supervisor, __MODULE__}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
