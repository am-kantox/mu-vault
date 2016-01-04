defmodule MuVault.RequestTest do
  use ExUnit.Case
  doctest MuVault.Request

  test "request puts and reads value successfully" do
    connector = %MuVault.Connector{ address: "http://127.0.0.1:8200" }
    key = "/secret/foo"
    {:ok, put_result} = MuVault.Request.put connector, key, %{key: "value"}
    {{_, put_response_status, _}, _, _} = put_result
    assert put_response_status == 204

    {:ok, get_result} = MuVault.Request.get connector, key
    {_, _, get_response} = get_result
    assert get_response == '{"lease_id":"","renewable":false,"lease_duration":2592000,"data":{"key":"value"},"warnings":null,"auth":null}\n'
  end
end
