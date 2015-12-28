# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :mu_vault, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:mu_vault, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

defmodule MuVault.Config do

  @version "0.1.0"
  @user_agent "VaultElixir/#{@version} (+github.com/am-kantox/mu_vault)"

  config :mu_vault,
    version: @version,
    user_agent: @user_agent,
    token_header: "X-Vault-Token",
    location_header: "location",
    default_headers: %{
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => @user_agent
    },
    json_parse_options: %{
      max_nesting:      false,
      create_additions: false,
      symbolize_names:  true
    }

end
