defmodule AnalyticTableaux.MixProject do
  use Mix.Project

  def project do
    [
      app: :analytic_tableaux,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      { :dialyxir, "~> 1.0", only: [:dev], runtime: false },
      { :propcheck, "~> 1.4", only: [:test] },
    ]
  end

  defp escript do
    [main_module: AnalyticTableaux.CLI]
  end
end
