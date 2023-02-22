defmodule ElhexDelivery.PostalCode.Store do
  use GenServer

  # alias ElhexDelivery.PostalCode.DataParser

  def start_link(args) do
    IO.inspect(args)
    IO.inspect("args")
    IO.inspect(args[:conf][:name])

    GenServer.start_link(__MODULE__, args, name: args[:conf][:name])
  end

  def init(args) do
    {:ok, {args, "initial store"}}
  end

  # def get_geolocation(postal_code) do
  #   GenServer.call(:postal_code_store, {:get_geolocation, postal_code})
  # end

  # # Callbacks
  # def handle_call({:get_geolocation, postal_code}, _from, geolocation_data) do
  #   geolocation = Map.get(geolocation_data, postal_code)
  #   {:reply, geolocation, geolocation_data}
  # end

  def get_store(module) do
    GenServer.call(module, :get_store)
  end

  def set_store(module, new_state) do
    GenServer.call(module, {new_state, :set_store})
  end

  # Callbacks
  def handle_call(:get_store, _from, actual_state) do
    {[_conf, _name], state} = actual_state
    {:reply, state, actual_state}
  end

  # Callbacks
  def handle_call({new_state, :set_store}, _from, actual_state) do
    {[conf, name], _old_state} = actual_state

    new_state_complete = {[conf, name], new_state}

    {:reply, new_state, new_state_complete}
  end

  # iex> {:ok, pid} = ElhexDelivery.PostalCode.Store.start_link
  # {:ok, #PID<0.188.0>}

  # n pode start dnv pq tem nome. Só um processo por name
  # iex> ElhexDelivery.PostalCode.Store.start_link
  # {:error, {:already_started, #PID<0.188.0>}}

  # iex> ElhexDelivery.PostalCode.Store.get_geolocation("94062")
  # {37.413691, -122.295343}
end
