defmodule DaisyUIForms.MixProject do
  use Mix.Project

  def project do
    [
      app: :daisyui_forms,
      version: "0.0.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
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
      {:phoenix_html, "~> 3.0"}
    ]
  end

  defp aliases do
    [
      ci: ["format --check-formatted", "test"]
    ]
  end
end
