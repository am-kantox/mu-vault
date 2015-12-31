# μVault

**[Vault](https://www.vaultproject.io) connector for Elixir**

## Credits

  * Thanks to José Valim for the great language

## Intro

This is a simple connector to Vault. It provides the API connection interface
for Elixir clients.

`μVault` is building it’s function list using the
[official documentation](https://www.vaultproject.io/docs/http/index.html).
This repo contains a snapshot of the current documentation, as by 31 Dec 2015.

For every endpoint it provides `N + 1` method, where N is a difference
between required and maximal amount of parameters, accepted by each endpoint.
For instance, for [`/sys/init`](https://www.vaultproject.io/docs/http/sys-init.html)
endpoint, the following functions are provided:

```elixir
iex(1)> MuVault.Utils.VaultDocParser.get_sys_init                     
'http://127.0.0.1:8200/v1/sys/init'
{:ok,
 {{'HTTP/1.1', 200, 'OK'},
  [{'date', 'Thu, 31 Dec 2015 11:56:48 GMT'}, {'content-length', '21'},
   {'content-type', 'application/json'}], '{"initialized":true}\n'}}
iex(2)> MuVault.Utils.VaultDocParser.get_sys_init %MuVault.Connector{address: "http://127.0.0.1:8200"}
'http://127.0.0.1:8200/v1/sys/init'
{:ok,
 {{'HTTP/1.1', 200, 'OK'},
  [{'date', 'Thu, 31 Dec 2015 11:57:14 GMT'}, {'content-length', '21'},
   {'content-type', 'application/json'}], '{"initialized":true}\n'}}
```

The struct `MuVault.Connector` accepts any parameter, accepted by original interface.

Also, general methods (`put`, `get`, `delete`, `post`) are available
in `MuVault.Request` module. All of them can be called with default settings,
or passing the `%MuVault.Connector{}` instance as the first parameter.

## ToDo

  * documentation for Standard API functions (already parsed from the site)
should be attached to generated methods to make it accessible in `iex`;
  * more distinct helpers for standard methods;
  * more tests.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add mu_vault to your list of dependencies in `mix.exs`:

        def deps do
          [{:mu_vault, "~> 0.0.1"}]
        end

  2. Ensure mu_vault is started before your application:

        def application do
          [applications: [:mu_vault]]
        end
