defmodule Moc.Connector.MixProject do
  use Mix.Project

  def project do
    [
      app: :moc_connector,
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
      {:moc_utils, path: "../utils"},
      {:jason, "~> 1.4"},
      {:httpoison, "~> 2.2"}
    ]
  end
end
