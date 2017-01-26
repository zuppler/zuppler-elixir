defmodule Zuppler.Address do
  @moduledoc """
  Zupper Address
  """
  # @enforce_keys [:street, :id]
  defstruct [:id, :city, :country, :state, :geo]
end
