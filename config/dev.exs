use Mix.Config

config :zuppler_elixir, Zuppler.Endpoint,
  restaurants_url: "http://restaurants.api.biznettechnologies.com"

config :zuppler_elixir, Zuppler.Endpoint,
  graphql_endpoint: "/graphql"

config :zuppler_elixir, Zuppler.Endpoint,
  check_address_endpoint: "/api/v5/restaurants/:restaurant_id/check_address/:address_id"
