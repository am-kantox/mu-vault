defmodule MuVault.RequestTest do
  use ExUnit.Case
  doctest MuVault.Request

  test "request puts and reads value successfully" do
    connector = %MuVault.Connector{ address: "http://127.0.0.1:8200" }
    key = "/secret/foo"
    MuVault.Request.put connector, key, '{"key": "value"}'
    {:ok, result} = MuVault.Request.get connector, key
    {_, _, response} = result
    assert response == '{"lease_id":"","renewable":false,"lease_duration":2592000,"data":{"key":"value"},"warnings":null,"auth":null}\n'
  end
end
