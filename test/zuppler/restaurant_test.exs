defmodule Zuppler.RestaurantTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "load restaurant" do
    use_cassette "restaurant" do
      query = """
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
      """
      {:ok, restaurant} = Zuppler.Restaurant.find(query)
      assert(restaurant.permalink == "demorestaurant")
      assert(restaurant.name == "demo")
    end
  end
end
