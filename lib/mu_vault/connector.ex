defmodule MuVault.Connector do
  @moduledoc "Represents an underlying httpc connector to vault server (uses values from `MuVault.Defaults` as defaults)"
  @vsn 1

  require MuVault.Maxros
  MuVault.Maxros.define_struct_with_defaults

end
