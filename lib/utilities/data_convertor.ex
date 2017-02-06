defmodule Zuppler.Utilities.DataConvertor do
  @moduledoc """
  Data Convertor module
  Used to convert from map to Restaurant struct
  """

  @doc """
  Convert a map to struct to enforce keys validation

  ## Example

      %{
        name: "demo", permalink: "demorestaurant",
        amenities: "Online Orders, Cocktail, Air Condition (A/C), Late Night, Coupons",
        cuisines: "Continental, Pizza, Seafood",
        locations: [%{city: "Norristown", country: nil, id: "685", state: "PA",
            geo: %{lat: 40.14543, lng: -75.393859}},
          %{city: "Phoenixville", country: nil, id: "350", state: "PA",
            geo: %{lat: 40.134154, lng: -75.516085}}
        ]
      }

      =>

      %Zuppler.Restaurant{
        name: "demo", permalink: "demorestaurant",
        amenities: "Online Orders, Cocktail, Air Condition (A/C), Late Night, Coupons",
        cuisines: "Continental, Pizza, Seafood",
        locations: [%Zuppler.Address{city: "Norristown", country: nil, id: "685", state: "PA",
            geo: %Zuppler.Address.Geo{lat: 40.14543, lng: -75.393859}},
          %Zuppler.Address{city: "Phoenixville", country: nil, id: "350", state: "PA",
            geo: %Zuppler.Address.Geo{lat: 40.134154, lng: -75.516085}}
        ]
      }
  """

  alias Zuppler.Restaurant
  alias Zuppler.Address

  @spec convert(%{optional(any) => any}) :: Restaurant.t
  def convert(map) do
    struct(Restaurant, map)
    |> add_locations
    |> add_services
  end

  defp add_locations(%Restaurant{locations: nil} = restaurant), do: restaurant
  defp add_locations(%Restaurant{locations: locations} = restaurant) do
    Map.put(restaurant, :locations, Enum.map(locations, &addr_convert(&1)) )
  end

  defp add_services(%Restaurant{services: nil} = restaurant), do: restaurant
  defp add_services(%Restaurant{services: services} = restaurant) do
    Map.put(restaurant, :services, Enum.map(services, &service_convert(&1)) )
  end

  @spec addr_convert(%{optional(any) => any}) :: Address.t
  defp addr_convert(adr) do
    new_adr = Map.put(adr, :geo, geo_convert(adr.geo) )
    struct(Address, new_adr)
  end

  @spec geo_convert(%{lat: float, lng: float}) :: Address.Geo.t
  defp geo_convert(geo) do
    struct(Address.Geo, geo)
  end

  @spec service_convert(%{optional(any) => any}) :: Zuppler.Service.t
  defp service_convert(srv) do
    struct(Zuppler.Service, srv)
  end
end
