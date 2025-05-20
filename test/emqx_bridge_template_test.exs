defmodule EmqxBridgeTemplateTest do
  use ExUnit.Case
  doctest EmqxBridgeTemplate

  test "greets the world" do
    assert EmqxBridgeTemplate.hello() == :world
  end
end
