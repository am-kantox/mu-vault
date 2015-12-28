defmodule MuVault.ConnectorTest do
  use ExUnit.Case
  doctest MuVault.Connector

  test "connector is initialized successfully with defaults" do
    connector = %MuVault.Connector{ }
    assert connector.address == MuVault.Defaults.address
    assert connector.token == MuVault.Defaults.token
  end

  test "connector is initialized successfully with values passed" do
    connector = %MuVault.Connector{ token: "token" }
    assert connector.address == "https://127.0.0.1:8200"
    assert connector.token == "token"
  end
end
