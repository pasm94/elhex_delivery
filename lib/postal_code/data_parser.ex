defmodule ElhexDelivery.PostalCode.DataParser do
  @postal_code_filepath "data/2016_Gaz_zcta_national.txt"

  def parse_data do
    [_header | data_rows] =
      @postal_code_filepath
      |> File.read!()
      |> String.split("\n")

    # Stream module means that the next function does not need to wait
    # the previous function to be finished to start
    data_rows
    |> Stream.map(&String.split(&1, "\t"))
    |> Stream.filter(&data_row?/1)
    |> Stream.map(&parse_data_columns/1)
    |> Stream.map(&format_row/1)
    |> Enum.into(%{})
  end

  defp data_row?([_, _, _, _, _, _, _] = _7_elements), do: true
  defp data_row?(_else), do: false

  defp parse_data_columns([postal_code, _, _, _, _, latitude, longitude]) do
    [postal_code, latitude, longitude]
  end

  defp parse_number(str), do: str |> String.replace(" ", "") |> String.to_float()

  # format three elems list into a two elements tuple
  # [postal_code, latitude, longitude] => {postal_code, latitude, longitude}
  defp format_row([postal_code, latitude, longitude]) do
    latitude = parse_number(latitude)
    longitude = parse_number(longitude)
    {postal_code, {latitude, longitude}}
  end
end
