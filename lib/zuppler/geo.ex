defmodule Zuppler.Address.Geo do
  @moduledoc """
  Address geo struct
  """
  @enforce_keys [:lat, :lng]
  defstruct [:lat, :lng]

  @type t :: %__MODULE__{lat: float, lng: float}
end
