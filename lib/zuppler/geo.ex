defmodule Zuppler.Address.Geo do
  @moduledoc """
  Address geo struct
  """
  @enforce_keys [:lat, :lng]
  defstruct [:lat, :lng]
end
