defmodule Zuppler.Utilities.DataConvertorTest do
  use ExUnit.Case

  test "convert map to struct" do
    data = %{
      name: "demo", permalink: "demorestaurant",
      amenities: "Online Orders, Cocktail, Air Condition (A/C), Late Night, Coupons",
      cuisines: "Continental, Pizza, Seafood",
      locations: [%{city: "Norristown", country: nil, id: "685", state: "PA",
          geo: %{lat: 40.14543, lng: -75.393859}},
        %{city: "Phoenixville", country: nil, id: "350", state: "PA",
          geo: %{lat: 40.134154, lng: -75.516085}}
      ]
    }
    expected = %Zuppler.Restaurant{
      name: "demo", permalink: "demorestaurant",
      amenities: "Online Orders, Cocktail, Air Condition (A/C), Late Night, Coupons",
      cuisines: "Continental, Pizza, Seafood",
      locations: [%Zuppler.Address{city: "Norristown", country: nil, id: "685", state: "PA",
          geo: %Zuppler.Address.Geo{lat: 40.14543, lng: -75.393859}},
        %Zuppler.Address{city: "Phoenixville", country: nil, id: "350", state: "PA",
          geo: %Zuppler.Address.Geo{lat: 40.134154, lng: -75.516085}}
      ]
    }
    result = Zuppler.Utilities.DataConvertor.convert(data)

    assert(result == expected)
  end
end
