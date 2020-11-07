Code.eval_file("mess.exs")
defmodule CommonsPub.WebPhoenix.MixProject do
  use Mix.Project

  def project do
    [
      app: :cpub_web_phoenix,
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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    Mess.deps [
      # you probably want to use messctl rather than adding deps here
      {:phoenix_live_reload, "~> 1.2", only: :dev}
    ]
  end

end
