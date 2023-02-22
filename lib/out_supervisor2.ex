defmodule OutSupervisor2 do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      {ElhexDelivery.Supervisor, conf: configs(), name: {:via, ElhexDelivery.Supervisor, configs()[:name]}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp configs do
    [
      name: __MODULE__,
      from: "94043",
      to: "94063",
    ]
  end
end
