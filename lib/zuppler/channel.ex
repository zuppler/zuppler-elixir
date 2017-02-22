defmodule Zuppler.Channel do
  @moduledoc """
  Zuppler Channel Wrapper
  """
  defstruct [:name, :permalink, :url, :login_required,
             :disabled, :searchable, :integrations]

  @type t :: %__MODULE__{
    name: String.t, permalink: String.t, url: String.t,
    login_required: boolean, disabled: boolean,
    searchable: boolean, integrations: [Integration.t]
  }

  require Logger
  alias Zuppler.Utilities.DataConvertor

  @doc """
    Get info about channel and integrations
    Ex:

    query =  \"\"\"
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
    \"\"\"
    variables = %{id: 121, remote_id: "milwakeeplace"}

    Zuppler.Channel.find(query, variables)
  """
  @spec find(String.t, nil | map) :: {:ok, %__MODULE__{}} | {:error, String.t}
  def find(query, variables \\ nil) do
    url = channel_url()
    Logger.info "Loading channel from #{url} \n with query: #{inspect(query)} \n and variables: #{inspect(variables)}"
    headers = ["Content-type": "application/json"]
    body = Poison.encode!(construct_body(query, variables))
    response = HTTPoison.post channel_url(), body, headers

    Logger.debug fn -> "Response: #{inspect(response.body)}" end

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: data}} ->
        %{data: %{channel: c}} = Poison.Parser.parse!(data, keys: :atoms)
        channel = DataConvertor.convert_channel(c)
        {:ok, channel}
      {:ok, %HTTPoison.Response{status_code: code, body: error_message}}
        when code == 400 or code == 500 ->
        {:error, error_message}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found :("}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, inspect(reason)}
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
