use Mix.Config

config :zuppler_elixir, Zuppler.Endpoint,
  restaurant_url: "http://restaurants.api.biznettechnologies.com/graphql"

config :exvcr, [
  vcr_cassette_library_dir: "test/vcr_cassettes",
  custom_cassette_library_dir: "test/custom_cassettes",
  filter_url_params: false,
  response_headers_blacklist: []
]
