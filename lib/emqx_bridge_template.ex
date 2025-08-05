defmodule EmqxBridgeTemplate do
  @templates (
               root = Path.expand("./templates", __DIR__)

               root
               |> Path.join("**/*.eex")
               |> Path.wildcard()
               |> Map.new(fn template ->
                 out_path =
                   template
                   |> String.replace_prefix(root <> "/", "")
                   |> String.replace_suffix(".eex", "")

                 {out_path, EEx.compile_file(template)}
               end)
             )

  def create_app(opts) do
    name = opts[:name]
    output_dir = opts[:output_dir]

    assigns = [
      name: opts[:name],
      pretty_name: opts[:pretty_name],
      current_year: Date.utc_today().year
    ]

    @templates
    |> Enum.each(fn {out_path, template_quoted} ->
      target = outfile(output_dir, out_path, name)
      {result, _} = Code.eval_quoted(template_quoted, assigns: assigns)
      Mix.Generator.create_file(target, result)
    end)

    Mix.shell().info([
      "\n",
      [
        :bright,
        "Extra things to do:\n",
        "  - Update `apps/emqx_machine/priv/reboot_lists.eterm`\n",
        "  - Update `apps/emqx_gen_bridge/src/emqx_connector_info.erl`\n",
        "  - Update `apps/emqx_gen_bridge/src/emqx_action_info.erl`\n",
        "  - Create corresponding `*.hocon` files in `rel/i18n/`\n",
        "  - Use `UMP.strict_erlc_opts` when done\n",
      ]
    ])
  end

  def outfile(output_dir, "mix.exs", _name) do
    Path.join([output_dir, "mix.exs"])
  end

  def outfile(output_dir, filepath, name) do
    [dir, filename] = Path.split(filepath)

    filename =
      case filename do
        "include.hrl" ->
          "emqx_bridge_#{name}.hrl"

        _ ->
          "emqx_bridge_#{name}_#{filename}"
      end

    Path.join([output_dir, dir, filename])
  end
end
