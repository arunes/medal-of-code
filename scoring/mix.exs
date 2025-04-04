defmodule Scoring.MixProject do
  use Mix.Project

  def project do
    [
      app: :moc_scoring,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:moc_counters, path: "../counters"},
      {:moc_data, path: "../data"},
      {:moc_utils, path: "../utils"}
    ]
  end
end
