defmodule Foobar2Test do
  use ExUnit.Case
  doctest Foobar2

  test "greets the world" do
    assert Foobar2.hello() == :world
  end
end
