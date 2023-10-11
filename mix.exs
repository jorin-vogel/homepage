defmodule JorinMe.MixProject do
  use Mix.Project

  def project do
    [
      app: :jorin_me,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {JorinMe.Application, []}
    ]
  end

  defp deps do
    [
      {:nimble_publisher, "~> 1.0.0"},
      {:makeup_elixir, "~> 0.16.1"},
      {:makeup_js, "~> 0.1.0"},
      {:phoenix_live_view, "~> 0.20.0"},
      {:esbuild, "~> 0.7.1"},
      {:tailwind, "~> 0.2.1"},
      {:bandit, "~> 0.7.7"},
      {:exsync, "~> 0.2"}
    ]
  end
end
