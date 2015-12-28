defmodule MuVault.Defaults do
  @moduledoc "Represents default parameters of underlying connection to vault server"
  @vsn 1

  ##############################################################################
  #### MACROS
  ##############################################################################

  @doc "The default vault address"
  defmacro vault_address do
    "https://127.0.0.1:8200"
  end

  @doc "The path to the vault token on disk"
  defmacro vault_disk_token do
    System.user_home |> Path.join(".vault-token")
  end

  @doc "The list of SSL ciphers to allow. You should not change this value unless you absolutely know what you are doing!"
  defmacro ssl_ciphers_allowed do
    "TLSv1.2:!aNULL:!eNULL"
  end

  @doc "The default number of attempts"
  defmacro retry_attempts do
    3
  end

  @doc "The default backoff interval"
  defmacro retry_base do
    0.05
  end

  @doc "The maximum amount of time for a single exponential backoff to sleep"
  defmacro retry_max_wait do
    2.0
  end

  ##############################################################################
  #### FUNCTIONS
  ##############################################################################

  @doc "The address to communicate with Vault"
  def address do
    System.get_env["VAULT_ADDR"] || vault_address
  end

  @doc "The vault token to use for authentiation"
  def token do
    case File.read(vault_disk_token) do
      {:ok, binary} -> binary
      {:error, _} -> System.get_env["VAULT_TOKEN"]
    end
  end

  @doc "The number of seconds to wait when trying to open a connection before timing out"
  def open_timeout do
    System.get_env["VAULT_OPEN_TIMEOUT"]
  end

  @doc "The HTTP Proxy server address as a string"
  def proxy_address do
    System.get_env["VAULT_PROXY_ADDRESS"]
  end

  @doc "The HTTP Proxy server username as a string"
  def proxy_username do
    System.get_env["VAULT_PROXY_USERNAME"]
  end

  @doc "The HTTP Proxy user password as a string"
  def proxy_password do
    System.get_env["VAULT_PROXY_PASSWORD"]
  end

  @doc "The HTTP Proxy server port as a string"
  def proxy_port do
    System.get_env["VAULT_PROXY_PORT"]
  end

  @doc "The number of seconds to wait when reading a response before timing out"
  def read_timeout do
    System.get_env["VAULT_READ_TIMEOUT"]
  end

  @doc "The ciphers that will be used when communicating with vault over ssl
        You should only change the defaults if the ciphers are not available on
        your platform and you know what you are doing"
  def ssl_ciphers do
    System.get_env["VAULT_SSL_CIPHERS"] || ssl_ciphers_allowed
  end

  @doc "The path to a pem on disk to use with custom SSL verification"
  def ssl_pem_file do
    System.get_env["VAULT_SSL_CERT"]
  end

  @doc "Passphrase to the pem file on disk to use with custom SSL verification"
  def ssl_pem_passphrase do
    System.get_env["VAULT_SSL_CERT_PASSPHRASE"]
  end

  @doc "The path to the CA cert on disk to use for certificate verification"
  def ssl_ca_cert do
    System.get_env["VAULT_CACERT"]
  end

  @doc "The path to the directory on disk holding CA certs to use for certificate verification"
  def ssl_ca_path do
    System.get_env["VAULT_CAPATH"]
  end

  @doc "[FIXME not elegant] Verify SSL requests (default: true)"
  def ssl_verify do
    case System.get_env["VAULT_SSL_VERIFY"] do
      nil -> true
      "y" <> _ -> true
      "Y" <> _ -> true
      "t" <> _ -> true
      "T" <> _ -> true
      _ -> false
    end
  end

  @doc "The number of seconds to wait for connecting and verifying SSL"
  def ssl_timeout do
    System.get_env["VAULT_SSL_TIMEOUT"]
  end

  @doc "A default meta-attribute to set all timeout values — individually set timeout values will take precedence"
  def timeout do
    System.get_env["VAULT_TIMEOUT"]
  end

end
