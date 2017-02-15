defmodule Zuppler.DeliveryInfo do
  @moduledoc """
  Loads the delivery info for restaurant and address
  """
  require Logger
  defstruct [:min_order_amount, :limit_order_amount, :charge_amount, :charge_percent, :time]

  @type t :: %__MODULE__{min_order_amount: float, limit_order_amount: integer,
                         charge_amount: float, charge_percent: float, time: integer}

  @spec find(integer, integer) :: {:ok, t} | {:error, String.t}
  def find(restaurant_id, address_id) when is_integer(restaurant_id) and is_integer(address_id), do:
    find(Integer.to_string(restaurant_id), Integer.to_string(address_id))

  @spec find(integer, String.t) :: {:ok, t} | {:error, String.t}
  def find(restaurant_id, address_id) when is_integer(restaurant_id) and is_binary(address_id), do:
    find(Integer.to_string(restaurant_id), address_id)

  @spec find(String.t, integer) :: {:ok, t} | {:error, String.t}
  def find(restaurant_id, address_id) when is_binary(restaurant_id) and is_integer(address_id), do:
    find(restaurant_id, Integer.to_string(address_id))

  @spec find(String.t, String.t) :: {:ok, t} | {:error, String.t}
  def find(restaurant_id, address_id) when is_binary(restaurant_id) and is_binary(address_id) do
    headers = ["Content-type": "application/json"]
    url = check_address_url(restaurant_id, address_id)
    Logger.info "Loading delivery rule settings from #{url}"

    response = HTTPoison.get url, headers

    Logger.debug fn -> "Response: #{inspect(response)}" end

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: data}} ->
        %{settings: settings} = Poison.Parser.parse!(data, keys: :atoms)
        {:ok, struct(__MODULE__, settings)}
      {:ok, %HTTPoison.Response{status_code: 400, body: error_message}} ->
        {:ok, %{"error" => message, "success" => false}} = Poison.Parser.parse(error_message)
        {:error, message}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found :("}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, inspect(reason)}
    end
  end

  @spec check_address_url(String.t, String.t) :: String.t
  defp check_address_url(restaurant_id, address_id) do
    config = Application.get_env(:zuppler_elixir, Zuppler.Endpoint)
    restaurant_url = config[:restaurants_url]
    check_address_endpoint = config[:check_address_endpoint]

    if is_nil(restaurant_url) do
      raise ArgumentError, message: "Restaurant url is not set. Please add it in config file"
    end
    if is_nil(check_address_endpoint) do
      raise ArgumentError, message: "Address endpoint url is not set. Please add it in config file"
    end

    url = config[:restaurants_url] <> config[:check_address_endpoint]
    url
    |> String.replace(":restaurant_id", restaurant_id)
    |> String.replace(":address_id", address_id)
  end
end
