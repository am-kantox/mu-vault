defmodule MuVault.Maxros do
  @moduledoc "Macros, needed to be defined outside of their modules, e.g. struct expansion"
  @vsn 1

  # alias MuVault.Defaults, as: Defaults
  # Vault.configure do |config|
  #   config.address = Diplomat::Kv.get('vault/leader')
  #   APP_ID  = Diplomat::Kv.get('vault/app_id/db_prod')
  #   USER_ID = get_mac_address ($1.gsub!(':','-') if `#{'ifconfig'}`=~/ether.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im)
  #   config.token = Vault.auth.app_id(APP_ID, USER_ID).auth[:client_token]
  # end

  # [AM FIXME] unquote:
  # Enum.each(Dict.keys(MuVault.Defaults.__info__(:macros)), fn(k) -> quote do def unquote(k) do unquote(k) end end
  #
  #    defstruct address: Defaults.address, token: Defaults.token
  defmacro define_struct_with_defaults do
    quote do
      defstruct Map.to_list(quote do: unquote(Enum.reduce(Dict.keys(MuVault.Defaults.__info__(:functions)), %{}, fn(k, acc) ->
        Map.put(acc, :"#{k}", apply(MuVault.Defaults, :"#{k}", []))
      end)))
    end
  end

end
