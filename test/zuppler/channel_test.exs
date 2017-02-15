defmodule Zuppler.ChannelTest do
  @moduledoc """
  Test for Channel entity
  """

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @query """
    query ChannelWithIntegration($id: ID, $remote_id: String) {
        channel(id: $id) {
          name
          permalink
          url
          disabled
          searchable
          integrations(remote_id: $remote_id){
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
      variables = %{"id" => 121, "remote_id" => "milmontpark"}

      {:ok, channel} = Zuppler.Channel.find(@query, variables)
      assert(channel.permalink == "swissfarms")
      assert(channel.name == "Swiss Farms")
      i = channel.integrations |> List.first
      assert(i.restaurant_location_id == 739)
      assert(i.restaurant_id == 775)
    end
  end
end
