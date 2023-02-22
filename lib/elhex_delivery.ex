defmodule ElhexDelivery do
  use Application

  def start(_type, _args) do
    children = []
    # children = [ElhexDelivery.Supervisor]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def get do
    ElhexDelivery.PostalCode.Store.get_store(OutSupervisor)
  end

  def set(new_state) do
    ElhexDelivery.PostalCode.Store.set_store(OutSupervisor, new_state)
  end
end
