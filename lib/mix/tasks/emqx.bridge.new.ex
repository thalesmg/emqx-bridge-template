defmodule Mix.Tasks.Emqx.Bridge.New do
  use Mix.Task

  @shortdoc "Creates a new EMQX bridge (connector + action) application"

  @moduledoc """
  Creates a new EMQX bridge (connector + action) application

  ## Options

    * `--name` - the short name to be used in module names and code.

    * `--pretty-name` - the name to be used in docstrings and descriptions for users.

    * `--output-dir` - the path to EMQX `apps/emqx_bridge_$NAME` directory where the
      templates will be instantiated.

    * `--i18n-out` - the path to EMQX root directory, so i18n files will be output to
      `rel/i18n`.  Optional.

  ## Examples

      $ mix emqx.bridge.new --name s3tables --pretty-name "S3 Tables" --output-dir /path/to/emqx/apps/emqx_bridge_s3tables --i18n-out /path/to/emqx/root

  """

  @impl true
  def run(args) do
    spec = [
      strict: [
        output_dir: :string,
        name: :string,
        pretty_name: :string,
        i18n_out: :string
      ]
    ]

    {opts, []} = OptionParser.parse!(args, spec)
    opts[:name] || raise "--name is required"
    opts[:pretty_name] || raise "--pretty-name is required"
    opts[:output_dir] || raise "--output-dir is required"

    EmqxBridgeTemplate.create_app(opts)
  end
end
