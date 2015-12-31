defmodule MuVault.Mixfile do
  use Mix.Project

  def project do
    [app: :mu_vault,
     version: "0.0.1",
     elixir: "~> 1.1",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :httpotion]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ { :ex_doc, github: "elixir-lang/ex_doc" },
      { :floki, "~> 0.7" },
      { :ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2" },
      { :httpotion, "~> 2.1.0" },

      { :credo, "~> 0.2", only: [:dev, :test] },
    ]
  end

  defp description do
    """
    Elixir binding / client library for Vault https://www.vaultproject.io/.
    It is basically the port of vault-ruby to Elixir.
    """
  end

  defp package do
    [# These are the default files included in the package
     files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: ["Aleksei Matiushkin"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/am-kantox/mu_vault",
              "Docs" => "http://am-kantox.github.io/my_vault/"}]
  end
end
