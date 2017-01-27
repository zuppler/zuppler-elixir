defmodule Zuppler.Utilities.DataConvertor do
  @moduledoc """
  Data Convertor module
  Used to convert from map to Zuppler.Restaurant struct
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
  @spec convert(%{optional(any) => any}) :: Zuppler.Restaurant.t
  def convert(map) do
    restaurant = struct(Zuppler.Restaurant, map)
    Map.put(restaurant, :locations, Enum.map(restaurant.locations, &addr_convert(&1)) )
  end

  @spec addr_convert(%{optional(any) => any}) :: Zuppler.Address.t
  defp addr_convert(adr) do
    new_adr = Map.put(adr, :geo, geo_convert(adr.geo) )
    struct(Zuppler.Address, new_adr)
  end

  @spec geo_convert(%{lat: float, lng: float}) :: Zuppler.Address.Geo.t
  defp geo_convert(geo) do
    struct(Zuppler.Address.Geo, geo)
  end
end
