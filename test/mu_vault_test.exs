defmodule MuVaultTest do
  use ExUnit.Case
  doctest MuVault

  test "vault should be installed" do
    assert System.cmd("whereis", ["vault"]) == { "vault: /usr/bin/vault\n", 0 }
  end
end
