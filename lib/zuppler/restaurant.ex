defmodule Zuppler.Restaurant do
  @moduledoc """
  Zupper Restaurant Wrapper
  """
  @enforce_keys [:permalink, :name]
  defstruct [:amenities, :cuisines, :permalink, :locations, :name, :services, :locale]

  @type t :: %__MODULE__{name: String.t, permalink: String.t,
                         amenities: String.t, cuisines: String.t,
                         services: list(Zuppler.Service.t),
                         locations: list(Zuppler.Location.t),
                         locale: String.t}

  require Logger
  alias Zuppler.Utilities.DataConvertor

  @doc """
  Load Zuppler Retaurant by graphql query

  ## Example
      Zuppler.Restaurant.find(\"\"\"
        {
          restaurant(id: 242) {
            name
            id
            cuisines
            amenities
            locations {
              id
              address {
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
        }
        \"\"\"
      )
  should return something like this:

      {:ok, %Zuppler.Restaurant{amenities: "Online Orders, Cocktail, Air Condition (A/C), Late Night",
        cuisines: "Continental, Pizza, Seafood",
        locations: [
          %Zuppler.Location{
            id: 1,
            %Zuppler.Address{city: "Norristown", country: nil,
              geo: %Zuppler.Address.Geo{lat: 40.14543, lng: -75.393859}, id: "685",
              state: "PA"}
          },
          %Zuppler.Location{
            id: 2,
            %Zuppler.Address{city: "Conshohocken", country: "US",
              geo: %Zuppler.Address.Geo{lat: 40.074143, lng: -75.292784}, id: "757230",
              state: "PA"}
          }
          ],
        name: "demo", permalink: "demorestaurant"}
      }

  or

      {:error, message}
  """
  @spec find(String.t) :: {:ok, %__MODULE__{}} | {:error, String.t}
  def find(query) do
    find_restaurant(%{query: query})
  end

    @doc """
  Load Zuppler Retaurant by named graphql query with variables

  ## Example
      query = \"\"\"
        query RestaurantById($id: ID) {
          restaurant(id: $id) {
            name
            id
            cuisines
            amenities
            locations {
              id
              address {
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
        }
      \"\"\"
      variables = %{id: 242}
      Zuppler.Restaurant.find(query, variables)

  should return something like this:

      {:ok, %Zuppler.Restaurant{amenities: "Online Orders, Cocktail, Air Condition (A/C), Late Night",
        cuisines: "Continental, Pizza, Seafood",
        locations: [
          %Zuppler.Location{
            id: 1,
            %Zuppler.Address{city: "Norristown", country: nil,
              geo: %Zuppler.Address.Geo{lat: 40.14543, lng: -75.393859}, id: "685",
              state: "PA"}
          },
          %Zuppler.Location{
            id: 2,
            %Zuppler.Address{city: "Conshohocken", country: "US",
              geo: %Zuppler.Address.Geo{lat: 40.074143, lng: -75.292784}, id: "757230",
              state: "PA"}
          }
          ],
        name: "demo", permalink: "demorestaurant"}
      }

  or

      {:error, message}
  """
  @spec find(String.t, map) :: {:ok, %__MODULE__{}} | {:error, String.t}
  def find(query, variables) do
    find_restaurant(%{query: query, variables: variables})
  end

  defp find_restaurant(body_content) do
    url = restaurant_url()
    Logger.info "Loading restaurant from \"#{url}\" with params:"
    Logger.info inspect(body_content, pretty: true)

    headers = ["Content-type": "application/json"]
    body = Poison.encode!(body_content)
    response = HTTPoison.post url, body, headers

    Logger.debug fn -> "Response: #{inspect(response)}" end

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
        {:error, inspect(reason)}
    end
  end

  @spec restaurant_url() :: String.t
  defp restaurant_url do
    config = Application.get_env(:zuppler_elixir, Zuppler.Endpoint)
    config[:restaurants_url] <> config[:graphql_endpoint]
  end
end
