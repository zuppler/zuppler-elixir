defmodule Zuppler.DeliveryInfoTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "load restaurant delivery_info available" do
    use_cassette "delivery_info" do
      {:ok, delivery_info} = Zuppler.DeliveryInfo.find(242, 772712)
      assert delivery_info.min_order_amount == 20
      assert delivery_info.limit_order_amount == 0
      assert delivery_info.charge_amount == 2.0
      assert delivery_info.charge_percent == 0
      assert delivery_info.time == 45
    end
  end

  test "load restaurant delivery_info not found" do
    use_cassette "delivery_info_not_found" do
      {:error, message} = Zuppler.DeliveryInfo.find(242, 772603)
      assert message == "does_not_deliver_to_address"
    end
  end
end
