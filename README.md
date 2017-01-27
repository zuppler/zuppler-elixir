# Zuppler Elixir

Elixir wrappers for Zuppler Endpoints

## Instalation

First add zuppler_elixir to your `mix.exs` dependecies:

```elixir
  [{:zuppler_elixir, "~> 0.0.1"}]
```

and run `$ mix deps.get`.

## Available resouces in this package

  * Restaurant GRAPHQL endpoint:

This endpoint will expose all the important restaurant fields to be consumed from server and mobile clients

```elixir
Zuppler.Restaurant.find(query)
```
