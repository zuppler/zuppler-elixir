defmodule Zuppler.Channel do
  @moduledoc """
  Zuppler Channel Wrapper
  """
  defstruct [:name, :permalink, :integration, :url, :zuppler_commission_id, :menu_url,
             :mobile_menu_url, :owner_id, :secret, :use_external_account, :commission_id,
             :no_restaurant_ambassador, :login_required, :disabled, :searchable, :integrations]

  @type t :: %__MODULE__{
    name: String.t, permalink: String.t, integration: boolean, url: String.t,
    menu_url: String.t, mobile_menu_url: String.t, use_external_account: boolean,
    commission_id: integer, login_required: boolean, disabled: boolean,
    searchable: boolean, integrations: [Integration.t]
  }

  alias Zuppler.Utilities.DataConvertor

  @spec find(String.t, nil | map) :: {:ok, %__MODULE__{}} | {:error, String.t}
  def find(query, variables \\ nil) do
    headers = ["Content-type": "application/json"]
    body = Poison.encode!(construct_body(query, variables))
    response = HTTPoison.post channel_url(), body, headers

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: data}} ->
        %{data: %{channel: c}} = Poison.Parser.parse!(data, keys: :atoms)
        channel = DataConvertor.convert_channel(c)
        {:ok, channel}
      {:ok, %HTTPoison.Response{status_code: 400, body: error_message}} ->
        {:error, error_message}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found :("}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, IO.inspect reason}
    end
  end

  defp construct_body(query, nil) do
    %{query: query}
  end

  defp construct_body(query, variables) do
    %{query: query, variables: variables}
  end

  @spec channel_url() :: String.t
  defp channel_url do
    config = Application.get_env(:zuppler_elixir, Zuppler.Endpoint)
    config[:restaurants_url] <> config[:graphql_endpoint]
  end
end
