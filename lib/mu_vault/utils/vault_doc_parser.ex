defmodule MuVault.Utils.VaultDocParser do
  @moduledoc "Internal helper to build Vault API by the documentation provided by Vault"

  defmodule MuMethod do
    @moduledoc "Struct to describe internal Vault API methods"
    defstruct [:description, :method, :parameters, :returns]
  end

  defmodule MuFloki do
    @moduledoc "Vault website parser based on Floki (internal use only)"

    def parse(file) do
      parse_html File.read!(file)
    end

    # FIXME parse parameters!!!
    defp parse_methods(methods) do
      # [{"Description", ["\nReturn the initialization status of a Vault.\n"]},
      #  {"Method", ["GET"]}, {"Parameters", ["None"]}, {"Returns", []},
      #  {"Garbage", []}]
      for method <- methods do
        m = (for { name, desc } <- method, into: %{}, do: {
          :"#{String.downcase(name)}", (case desc do
                                        <<_ :: binary>> -> String.strip(desc)
                                        _ -> desc
                                        end)
        })
        struct(MuMethod, m)
      end
    end

    defp parse_html(text) do
      [{ "h1", _, [title] } | _] = text |> Floki.find("#main-content div div h1")

      methods =
        for { "dl", _, method } <- Floki.find(text, "#main-content div div dl") do
          # {"p", [],
          #   [{"dt", [], ["Description"]},
          #    {"dd", [], ["\nReturn the initialization status of a Vault.\n"]}]},
          #    {"p", [], [{"dt", [], ["Method"]}, {"dd", [], ["GET"]}]},
          #    {"p", [], [{"dt", [], ["Parameters"]}, {"dd", [], ["None"]}]},
          #    {"p", [], [{"dt", [], ["Returns"]}, {"dd", [], []}]},
          #    {"pre", [{"class", "highlight javascript"}],
          #     [{"code", [],
          #       [{"span", [{"class", "p"}], ["{"]},
          #        {"span", [{"class", "s2"}], ["\"initialize\""]},
          #        {"span", [{"class", "err"}], [":"]}, {"span", [{"class", "kc"}], ["true"]},
          #        {"span", [{"class", "p"}], ["}"]}]}]}, {"p", [], []}]

          for { "p", [], content } <- method do
            case content do
              [{ "dt", _, [term] }, { "dd", _, [] }] -> { term, "" }
              [{ "dt", _, [term] }, { "dd", _, [desc] }] -> { term, desc }
              [{ "dt", _, [term] }, { "dd", _, desc }] -> { term, Floki.raw_html(desc) } # AM FIXME join list as string
              _ -> :error
            end
            # case result do
            #   { k, "None" } -> { k, "" }
            #   _ -> result
            # end
          end
        end

      { title, parse_methods(methods) }
    end

  end

  @external_resource api_description_path = Path.join [File.cwd!, "data", Application.fetch_env!(:mu_vault, :vault_html_version)]
  { :ok, files } = api_description_path |> File.ls # [AM] UNDERSTAND how to make files private here (@files)
  @methods (for (file <- files) do
    MuFloki.parse Path.join(api_description_path, file)
  end)

  import MuVault.Request

  for { func_unescaped, descs } <- @methods do
    # {"/sys/key-status",
    #   [%MuVault.Utils.VaultDocParser.MuMethod{description: "Returns information about the current encryption key used by Vault.",
    #     method: "GET", parameters: "None",
    #     returns: "The \"term\" parameter is the sequential key number, and ..."}]}
    func = func_unescaped |> String.replace(~r/\W+/, "_")

    for desc <- descs do
      meth = String.downcase(desc.method)
      method_name = :"#{meth}#{func}"
      case meth do
        "get" ->
          def unquote(method_name)(connector), do: unquote(:"#{meth}")(connector, unquote(func_unescaped))
          def unquote(method_name)(), do: unquote(:"#{meth}")(unquote(func_unescaped))
        "delete" ->
          def unquote(method_name)(connector), do: unquote(:"#{meth}")(connector, unquote(func_unescaped))
          def unquote(method_name)(), do: unquote(:"#{meth}")(unquote(func_unescaped))
        "post" ->
          def unquote(method_name)(connector, parameters), do: unquote(:"#{meth}")(connector, unquote(func_unescaped), parameters)
          def unquote(method_name)(parameters), do: unquote(:"#{meth}")(unquote(func_unescaped), parameters)
        "put" ->
          def unquote(method_name)(connector, parameters), do: unquote(:"#{meth}")(connector, unquote(func_unescaped), parameters)
          def unquote(method_name)(parameters), do: unquote(:"#{meth}")(unquote(func_unescaped), parameters)
        _ -> :not_implemented # requires more precise parsing of parameters
      end
    end
  end
end
