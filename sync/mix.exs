defmodule Moc.Sync.MixProject do
  use Mix.Project

  def project do
    [
      app: :sync,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Moc.Sync.Application, []},
      extra_applications: [:logger, :eex, :observer, :wx, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:db, path: "../db"},
      {:connector, path: "../connector/"}
    ]
  end
end
