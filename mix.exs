defmodule CommonsPub.Core.MixProject do
  use Mix.Project

  def project do
    [
      app: :cpub_core,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:pointers, git: "https://github.com/commonspub/pointers", branch: "main"},
      {:flexto, "~> 0.2"},
      {:phoenix, "~> 1.5.3"},
      {:phoenix_live_view, "~> 0.14"},
      {:gettext, "~> 0.11"}
    ]
  end

end
