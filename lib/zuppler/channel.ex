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
    Get info about channel and integrations by query
    Ex:

    query =  \"\"\"
      {
        channel(id: 1) {
          name
          permalink
          url
          disabled
          searchable
          integrations(remote_id: "gigi"){
            restaurant_location_id
            restaurant_id
          }
        }
      }
    \"\"\"

    Zuppler.Channel.find(query)
  """
  @spec find(String.t) :: {:ok, %__MODULE__{}} | {:error, String.t}
  def find(query) do
    body = %{query: query}
    find_in_restaurants(body)
  end

  @doc """
    Get info about channel and integrations by named query with variables
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
  @spec find(String.t, map) :: {:ok, %__MODULE__{}} | {:error, String.t}
  def find(query, variables) do
    body = %{query: query, variables: variables}
    find_in_restaurants(body)
  end

  defp find_in_restaurants(body_params) do
    url = channel_url()
    Logger.info "Loading channel from \"#{url}\" with params:"
    Logger.info inspect(body_params, pretty: true)

    headers = ["Content-type": "application/json"]
    body = Poison.encode!(body_params)
    response = HTTPoison.post channel_url(), body, headers

    Logger.debug fn -> "Response: #{inspect(response)}" end

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

  @spec channel_url() :: String.t
  defp channel_url do
    config = Application.get_env(:zuppler_elixir, Zuppler.Endpoint)
    config[:restaurants_url] <> config[:graphql_endpoint]
  end
end
