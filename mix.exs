defmodule Scribble.MixProject do
  use Mix.Project

  @external_resource path = Path.join(__DIR__, "VERSION")
  @version path |> File.read!() |> String.trim()

  def project do
    [
      app: :scribble,
      version: @version,
      elixir: "~> 1.7",
      package: package(),
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: ["test/automated"],
      consolidate_protocols: consolidate_protocols(Mix.env()),
      preferred_cli_env: [
        itest: :dev
      ],
      dialyzer: [
        plt_add_apps: [:mnesia],
        flags: [
          :unmatched_returns,
          :error_handling,
          :race_conditions
        ],
        paths: ["_build/#{Mix.env()}/lib/scribble/consolidated"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def package do
    [
      description: "Wrapper for Logger, with configurable levels and tagging",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/rill-project/scribble"},
      source_url: "https://github.com/rill-project/scribble",
      homepage_url: "https://github.com/rill-project/scribble"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:dialyxir, ">= 1.0.0-rc.3", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.19.2", only: [:dev]}
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/automated/support"]
  def elixirc_paths(_), do: ["lib"]

  def consolidate_protocols(:test), do: false
  def consolidate_protocols(:dev), do: false
  def consolidate_protocols(_), do: true

  def aliases do
    [
      itest: ["run"]
    ]
  end
end
