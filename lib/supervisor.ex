defmodule ElhexDelivery.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      {ElhexDelivery.PostalCode.Supervisor, []}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
