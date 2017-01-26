defmodule Zuppler.Restaurant do
  @moduledoc """
  Zupper Restaurant
  """
  @enforce_keys [:permalink, :name]
  defstruct [:amenities, :cuisines, :permalink, :locations, :name]

  alias Zuppler.Utilities.DataConvertor

  @doc """
  Load Zuppler Retaurant by graphql query
  Ex:
  Zuppler.Restaurant.find(
    {
      restaurant(permalink: "demorestaurant") {
        name
        permalink
        cuisines
        amenities
        locations {
          id
          city
          country
          state
          geo {
            lat
            lng
          }
        }
      }
    }
  )
  should return something like this:

  {:ok, %Zuppler.Restaurant{amenities: "Online Orders, Cocktail, Air Condition (A/C), Late Night",
    cuisines: "Continental, Pizza, Seafood",
    locations: [%Zuppler.Address{city: "Norristown", country: nil,
        geo: %Zuppler.Address.Geo{lat: 40.14543, lng: -75.393859}, id: "685",
        state: "PA"},
      %Zuppler.Address{city: "Conshohocken", country: "US",
        geo: %Zuppler.Address.Geo{lat: 40.074143, lng: -75.292784}, id: "757230",
        state: "PA"}],
    name: "demo", permalink: "demorestaurant"}
  }

  or

  {:error, message}
  """
  def find(query) do
    headers = ["Content-type": "application/json"]
    body = Poison.encode!(%{query: query})
    response = HTTPoison.post restaurant_url(), body, headers

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: data}} ->
        %{data: %{restaurant: r}} = Poison.Parser.parse!(data, keys: :atoms)
        restaurant = DataConvertor.convert(r)
        {:ok, restaurant}
      {:ok, %HTTPoison.Response{status_code: 400, body: error_message}} ->
        {:error, error_message}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found :("}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, IO.inspect reason}
    end
  end

  defp restaurant_url do
    config = Application.get_env(:zuppler_elixir, Zuppler.Endpoint)
    config[:restaurant_url]
  end
end
