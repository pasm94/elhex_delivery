defmodule ElhexDelivery.PostalCode.NavigatorTest do
  use ExUnit.Case

  alias ElhexDelivery.PostalCode.Navigator

  doctest ElhexDelivery

  describe "get_distance" do
    test "basic test" do
      distance = Navigator.get_distance("94062", "94104")

      assert distance == 26.75
    end

    @tag :capture_log
    test "postal code unexpected format" do
      navigator_pid = Process.whereis(:postal_code_navigator)
      reference = Process.monitor(navigator_pid)

      catch_exit(Navigator.get_distance("94062", 94104.981))

      assert_received({
        :DOWN,
        ^reference,
        :process,
        ^navigator_pid,
        {%ArgumentError{}, _}
      })
    end
  end
end
