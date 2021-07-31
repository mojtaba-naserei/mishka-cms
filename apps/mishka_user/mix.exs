defmodule MishkaUser.MixProject do
  use Mix.Project

  def project do
    [
      app: :mishka_user,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :mishka_database, :phoenix, :mnesia, :mishka_content],
      mod: {MishkaUser.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mishka_database, in_umbrella: true},
      {:mishka_content, in_umbrella: true},
      {:plug, "~> 1.11"},
      {:guardian, "~> 2.1"},
      {:phoenix, "~> 1.5.7"}
    ]
  end
end
