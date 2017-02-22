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
        restaurant(id: 242) {
          name
          permalink
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
          services {
            id
          }
        }
      }
      """
      {:ok, restaurant} = Zuppler.Restaurant.find(query)
      assert(restaurant.permalink == "demorestaurant")
      assert(restaurant.name == "demo")
    end
  end

  test "load restaurant with params" do
    use_cassette "restaurant_with_params" do
      query = """
      query RestaurantById($id: ID) {
        restaurant(id: $id) {
          name
          permalink
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
          services {
            id
          }
        }
      }
      """
      {:ok, restaurant} = Zuppler.Restaurant.find(query, %{id: 242})
      assert(restaurant.permalink == "demorestaurant")
      assert(restaurant.name == "demo")
    end
  end

  test "load restaurant locations" do
    use_cassette "restaurant_locations" do
      query = """
      {
        restaurant(id: 242) {
          locations {
            id
          }
        }
      }
      """
      {:ok, restaurant} = Zuppler.Restaurant.find(query)
      loc = restaurant.locations |> List.first
      assert(loc)
      assert(loc.id)
    end
  end
end
