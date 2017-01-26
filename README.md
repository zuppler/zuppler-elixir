# Zuppler Elixir

Elixir wrappers for Zuppler Endpoints

## Restaurant GRAPHQL endpoint

This endpoint will expose all the important restaurant fields to be consumed from server and mobile clients

  * Restaurant data can be query with this endpoint:

```elixir
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
```

  should return something like this:

```elixir
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
```
