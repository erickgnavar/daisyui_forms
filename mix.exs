defmodule DaisyUIForms.MixProject do
  use Mix.Project

  def project do
    [
      app: :daisyui_forms,
      version: "0.0.1",
      elixir: "~> 1.11",
      description: "Helper module to generate form elements with DaisyUI",
      package: package(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/erickgnavar/daisyui_forms"}
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
      {:phoenix_html, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      ci: ["format --check-formatted", "test"]
    ]
  end
end
