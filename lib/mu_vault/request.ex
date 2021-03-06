defmodule MuVault.Request do
  @moduledoc "Represents an underlying httpc request to vault server"
  @vsn 1

  alias MuVault.Connector, as: Connector

  defp address_token(connector, key) do
    [
      String.to_char_list("#{connector.address}/v1#{key}"),
      String.to_char_list(connector.token)
    ]
  end

  @paramless [ :get, :delete ]
  @paramfull [ :put, :post ] # :patch is not used

################################################################################

  # iex> {:ok, result} = :httpc.request(:get, {'http://127.0.0.1:8200/v1/secret/foo',
  #                      [{'X-Vault-Token', 'b759a13b-5129-c66f-22ae-fa9cdadf7969'}]}, [], [])
  # {:ok,
  #  {{'HTTP/1.1', 200, 'OK'},
  #   [{'date', 'Mon, 28 Dec 2015 12:59:10 GMT'}, {'content-length', '110'},
  #    {'content-type', 'application/json'}],
  #   '{"lease_id":"","renewable":false,"lease_duration":2592000,"data":{"value":"bar"},"warnings":null,"auth":null}\n'}}
  for term <- @paramless do
    @doc "Generic paramless handler for requesting data from vault (custom connector)"
    def unquote(term)(connector, key) do
      [address, token] = address_token(connector, key)
      :httpc.request(unquote(term), {address, [{'X-Vault-Token', token}]}, [], [])
    end

    @doc "Generic paramless handler for requesting data from vault (default connector)"
    def unquote(term)(key) do
      connector = %Connector{ address: "http://127.0.0.1:8200" }
      unquote(term)(connector, key)
    end
  end

################################################################################

  # iex> {:ok, result} = :httpc.request(:put, {'http://127.0.0.1:8200/v1/secret/foo',
  #                      [{'X-Vault-Token', 'b759a13b-5129-c66f-22ae-fa9cdadf7969'}], 'application/json', '{"value": "bar"}'}, [], [])
  # {:ok,
  #  {{'HTTP/1.1', 204, 'No Content'},
  #   [{'date', 'Mon, 28 Dec 2015 12:59:05 GMT'},
  #    {'content-type', 'application/json'}], []}}
  for term <- @paramfull do
    @doc "Generic paramfull handler for storing data in vault (custom connector)"
    def unquote(term)(connector, key, map) do
      [address, token] = address_token(connector, key)
      { :ok, encoded } = JSON.encode(map)
      :httpc.request(unquote(term), {address, [{'X-Vault-Token', token}], 'application/json', encoded}, [], [])
    end

    @doc "Generic paramfull handler for storing data in vault (default connector)"
    def unquote(term)(key, map) do
      connector = %Connector{ address: "http://127.0.0.1:8200" }
      unquote(term)(connector, key, map)
    end
  end

end
