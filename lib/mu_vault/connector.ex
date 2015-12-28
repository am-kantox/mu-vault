defmodule MuVault.Connector do
  @moduledoc "Represents an underlying httpc connector to vault server (uses values from `MuVault.Defaults` as defaults)"
  @vsn 1

  alias MuVault.Defaults, as: Defaults
  # Vault.configure do |config|
  #   config.address = Diplomat::Kv.get('vault/leader')
  #   APP_ID  = Diplomat::Kv.get('vault/app_id/db_prod')
  #   USER_ID = get_mac_address ($1.gsub!(':','-') if `#{'ifconfig'}`=~/ether.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im)
  #   config.token = Vault.auth.app_id(APP_ID, USER_ID).auth[:client_token]
  # end

  # [AM FIXME] unquote:
  # Enum.each(Dict.keys(MuVault.Defaults.__info__(:macros)), fn(k) -> quote do def unquote(k) do unquote(k) end end
  defstruct address: Defaults.address,
            token: Defaults.token


end
