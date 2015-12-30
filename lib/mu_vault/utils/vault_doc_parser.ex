defmodule MuVault.Utils.VaultDocParser do
  defmodule MuMethod do
    defstruct [:description, :method, :parameters, :returns]
  end

  defmodule MuXmerl do
    require Record
    Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
    Record.defrecord :xmlText,    Record.extract(:xmlText,    from_lib: "xmerl/include/xmerl.hrl")

    def parse(file) do
      File.read!(file)
      |> scan_text
      |> parse_xml
    end

    defp scan_text(text) do
      :xmerl_scan.string(String.to_char_list(text))
    end

    defp parse_xml({ xml, _ }) do
      # single element (header aka endpoint)
      [header]  = :xmerl_xpath.string('//*[@id="main-content"]/div/div/h1', xml)
      [text]     = xmlElement(header, :content)
      value      = xmlText(text, :value)
      IO.inspect to_string(value)
      # => "/sys/init"

      # multiple elements
      elements   = :xmerl_xpath.string('//*[@id="main-content"]/div/div/dl', xml)
      Enum.each(
        elements,
        fn(element) ->
          [text]     = xmlElement(element, :content)
          value      = xmlText(text, :value)
          IO.inspect to_string(value)
        end
      )
      # => "Belgian Waffles"
      # => "Strawberry Belgian Waffles"
      # => "Berry-Berry Belgian Waffles"
      # => "French Toast"
      # => "Homestyle Breakfast"
    end
  end

  defmodule MuFloki do

    def parse(file) do
      File.read!(file)
      |> parse_html
    end

    # FIXME parse parameters!!!
    defp parse_methods(methods) do
      # [{"Description", ["\nReturn the initialization status of a Vault.\n"]},
      #  {"Method", ["GET"]}, {"Parameters", ["None"]}, {"Returns", []},
      #  {"Garbage", []}]
      for method <- methods do
        m = for { name, desc } <- method, into: %{}, do: { :"#{String.downcase(name)}", desc }
        struct(MuMethod, m)
      end
    end

    defp parse_html(text) do
      [{ "h1", _, [title] } | _] = text
                                   |> Floki.find("#main-content div div h1")

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
              [{ "dt", _, [term] }, { "dd", _, ["None"] }] -> { term, "" }
              [{ "dt", _, [term] }, { "dd", _, [desc] }] -> { term, desc }
              [{ "dt", _, [term] }, { "dd", _, [desc | _] }] -> { term, desc } # AM FIXME join list as string
              _ -> :error
            end
          end
        end

      { title, parse_methods(methods) }
    end

  end
end
