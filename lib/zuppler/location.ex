defmodule Zuppler.Location do
  @moduledoc """
  Zupper Restaurant Location
  """
  # @enforce_keys [:street, :id]
  defstruct [:id, :address]

  @type t :: %__MODULE__{id: pos_integer, address: Zuppler.Address.t}
end
