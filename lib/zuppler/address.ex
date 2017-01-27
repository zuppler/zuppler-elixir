defmodule Zuppler.Address do
  @moduledoc """
  Zupper Address
  """
  # @enforce_keys [:street, :id]
  defstruct [:id, :city, :country, :state, :geo]

  @type t :: %__MODULE__{id: pos_integer, city: String.t, country: String.t, state: String.t,
                         geo: Zuppler.Address.Geo.t}

end
