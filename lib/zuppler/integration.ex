defmodule Zuppler.Integration do
  @moduledoc """
  Zuppler Restaurant Integration Wrapper
  """

  defstruct [:remote_id, :show_description, :use_tabs, :platform, :restaurant_id,
             :restaurant_location_id, :cart_location, :featured_cd, :disabled]

  @type t :: %__MODULE__{
    remote_id: String.t, show_description: boolean, use_tabs: boolean, platform: String.t,
    restaurant_id: integer, restaurant_location_id: integer,
    cart_location: String.t, featured_cd: integer, disabled: boolean
  }
end
