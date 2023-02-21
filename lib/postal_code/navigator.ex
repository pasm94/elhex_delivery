defmodule ElhexDelivery.PostalCode.Navigator do
  use GenServer

  alias ElhexDelivery.PostalCode.Cache
  alias ElhexDelivery.PostalCode.Store

  # @radius 6371 km
  @radius 3959

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: :postal_code_navigator)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def get_distance(from, to) do
    GenServer.call(:postal_code_navigator, {:get_distance, from, to})
  end

  # Callbacks

  def handle_call({:get_distance, from, to}, _from, state) do
    distance = do_get_distance(from, to)
    {:reply, distance, state}
  end

  defp do_get_distance(from, to) do
    from = format_postal_code(from)
    to = format_postal_code(to)

    case Cache.get_distance(from, to) do
      nil ->
        {lat1, long1} = get_geolocation(from)
        {lat2, long2} = get_geolocation(to)

        distance = calculate_distance({lat1, long1}, {lat2, long2})
        Cache.set_distance(from, to, distance)
        distance

      distance ->
        distance
    end
  end

  defp get_geolocation(postal_code) do
    Store.get_geolocation(postal_code)
  end

  defp format_postal_code(postal_code) when is_binary(postal_code), do: postal_code

  defp format_postal_code(postal_code) when is_integer(postal_code),
    do: Integer.to_string(postal_code)

  defp format_postal_code(postal_code) do
    error = "unexpected `postal_code`, received: (#{inspect(postal_code)})"

    raise ArgumentError, error
  end

  defp calculate_distance({lat1, long1}, {lat2, long2}) do
    lat_diff = degrees_to_radians(lat2 - lat1)
    long_diff = degrees_to_radians(long2 - long1)

    lat1 = degrees_to_radians(lat1)
    lat2 = degrees_to_radians(lat2)

    cos_lat1 = :math.cos(lat1)
    cos_lat2 = :math.cos(lat2)

    sin_lat_diff_sq = :math.sin(lat_diff / 2) |> :math.pow(2)
    sin_long_diff_sq = :math.sin(long_diff / 2) |> :math.pow(2)

    a = sin_lat_diff_sq + cos_lat1 * cos_lat2 * sin_long_diff_sq
    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))

    Float.round(@radius * c, 2)
  end

  defp degrees_to_radians(degrees) do
    degrees * (:math.pi() / 180)
  end
end
