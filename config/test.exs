use Mix.Config

config :zuppler_elixir, Zuppler.Endpoint,
  restaurants_url: "http://restaurants.api.biznettechnologies.com"

config :zuppler_elixir, Zuppler.Endpoint,
  graphql_endpoint: "/graphql"

config :zuppler_elixir, Zuppler.Endpoint,
  check_address_endpoint: "/api/v5/restaurants/:restaurant_id/check_address/:address_id"

config :exvcr, [
  vcr_cassette_library_dir: "test/vcr_cassettes",
  custom_cassette_library_dir: "test/custom_cassettes",
  filter_url_params: false,
  response_headers_blacklist: []
]

# Print only warnings and errors during test
config :logger, level: :info
