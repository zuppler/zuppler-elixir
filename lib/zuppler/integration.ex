defmodule Zuppler.Integration do
  @moduledoc """
  Zuppler Restaurant Integration Wrapper
  """

  defstruct [:remote_id, :show_description, :category_columns, :menu_columns, :menu_url,
             :reviews_url, :owner_id, :use_tabs, :reportjs, :platform, :menu_pictures,
             :zuppler_commision_id, :restaurant_location_id, :cart_location, :featured_cd, :disabled]

  @type t :: %__MODULE__{
    remote_id: String.t, show_description: boolean, category_columns: integer, menu_columns: integer,
    menu_url: String.t, reviews_url: String.t, owner_id: integer, use_tabs: boolean, reportjs: boolean,
    platform: String.t, menu_pictures: boolean, zuppler_commision_id: integer, restaurant_location_id: integer,
    cart_location: String.t, featured_cd: integer, disabled: boolean
  }
end
