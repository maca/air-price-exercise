defmodule AirPrice.MixProject do
  use Mix.Project

  def project do
    [
      app: :air_price,
      version: "0.0.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    port = Application.fetch_env!(:air_price, :port)

    [
      mod: {AirPrice, [{:port, port}]},
      extra_applications: [:logger, :httpoison, :timex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:sweet_xml, "~> 0.7"},
      {:timex, "~> 3.7"},
      {:cowboy, "~> 2.9"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
