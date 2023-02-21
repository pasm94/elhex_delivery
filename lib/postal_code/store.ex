defmodule ElhexDelivery.PostalCode.Store do
  use GenServer

  alias ElhexDelivery.PostalCode.DataParser

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: :postal_code_store)
  end

  def init(_) do
    {:ok, DataParser.parse_data()}
  end

  def get_geolocation(postal_code) do
    GenServer.call(:postal_code_store, {:get_geolocation, postal_code})
  end

  # Callbacks
  def handle_call({:get_geolocation, postal_code}, _from, geolocation_data) do
    geolocation = Map.get(geolocation_data, postal_code)
    {:reply, geolocation, geolocation_data}
  end

  # iex> {:ok, pid} = ElhexDelivery.PostalCode.Store.start_link
  # {:ok, #PID<0.188.0>}

  # n pode start dnv pq tem nome. Só um processo por name
  # iex> ElhexDelivery.PostalCode.Store.start_link
  # {:error, {:already_started, #PID<0.188.0>}}

  # iex> ElhexDelivery.PostalCode.Store.get_geolocation("94062")
  # {37.413691, -122.295343}
end
