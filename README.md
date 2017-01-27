# Zuppler Elixir

Elixir wrappers for Zuppler Endpoints

## Instalation

First add zuppler_elixir to your `mix.exs` dependecies:

```elixir
  [{:zuppler_elixir, "~> 0.0.1"}]
```

and run `$ mix deps.get`.
Then you need to setup the production url for zuppler endpoint. In `config/prod.exs` add:

```elixir
config :zuppler_elixir, Zuppler.Endpoint,
  restaurant_url: "production_url"
```

## Available resouces in this package

  * Restaurant GRAPHQL endpoint:

This endpoint will expose all the important restaurant fields to be consumed from server and mobile clients

```elixir
Zuppler.Restaurant.find(query)
```
