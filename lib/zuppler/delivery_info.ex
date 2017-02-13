defmodule Zuppler.DeliveryInfo do
  require Logger
  defstruct [:min_order_amount, :limit_order_amount, :charge_amount, :charge_percent, :time]

  @type t :: %__MODULE__{min_order_amount: float, limit_order_amount: integer,
                         charge_amount: float, charge_percent: float, time: integer}

  @spec find(integer, integer) :: {:ok, t} | {:error, String.t}
  def find(restaurant_id, address_id) do
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
        {:error, IO.inspect reason}
    end
  end

  @spec check_address_url(integer, integer) :: String.t
  defp check_address_url(restaurant_id, address_id) do
    config = Application.get_env(:zuppler_elixir, Zuppler.Endpoint)
    url = config[:restaurants_url] <> config[:check_address_endpoint]
    url
    |> String.replace(":restaurant_id", Integer.to_string(restaurant_id))
    |> String.replace(":address_id", Integer.to_string(address_id))
  end
end
