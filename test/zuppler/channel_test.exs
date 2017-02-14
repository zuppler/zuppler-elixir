defmodule Zuppler.ChannelTest do
  @moduledoc """
  Test for Channel entity
  """

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @query """
    query ChannelWithIntegration($permalink: String, $id: ID) {
        channel(permalink: $permalink) {
          name
          permalink
          url
          disabled
          searchable
          integrations(id: $id){
            restaurant_location_id
            restaurant_id
          }
        }
     }
  """

  setup_all do
    HTTPoison.start
  end

  test "load channel" do
    use_cassette "channel" do
      variables = %{"permalink" => "swissfarms", "id" => 3115}

      {:ok, channel} = Zuppler.Channel.find(@query, variables)
      assert(channel.permalink == "swissfarms")
      assert(channel.name == "Swiss Farms")
      i = channel.integrations |> List.first
      assert(i.restaurant_location_id == 1694)
      assert(i.restaurant_id == 775)
    end
  end
end
