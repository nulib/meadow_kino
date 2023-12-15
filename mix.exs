defmodule Meadow.Kino.MixProject do
  use Mix.Project

  def project do
    [
      app: :meadow_kino,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Meadow.Kino.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.12.0"},
      {:postgrex, "~> 0.17.4"}
    ]
  end
end
