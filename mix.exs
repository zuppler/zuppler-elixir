defmodule Zuppler.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :zuppler_elixir,
     name: "Zuppler Elixir Client",
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     docs: docs(),
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11.0"},
      {:poison, "~> 3.0"},
      {:mix_test_watch, "~> 0.2.6", only: :dev},
      {:exvcr, "~> 0.8.1", only: :test},
      {:ex_doc, ">= 0.13.0", only: [:dev]}
   ]
  end

  defp description do
    "Elixir Client to access Zuppler endpoints from Elixir projects"
  end

  defp docs do
    [extras: ["README.md"],
     main: "readme",
     source_ref: "v#{@version}",
     source_url: "https://github.com/zuppler/zuppler-elixir.git"]
  end

  defp package do
    [files: ["lib", "priv", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Silviu Rosu"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/zuppler/zuppler-elixir.git",
              "Docs" => ""}
    ]
  end
end
