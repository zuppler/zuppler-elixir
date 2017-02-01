defmodule Zuppler.Service do
  @moduledoc """
  Zupper Service wrapper (delivery, pickup, curbside)
  """
  @enforce_keys [:id]
  defstruct [:id, :description, :min_order, :default_time, :default_charge_amount]

  @type t :: %__MODULE__{id: pos_integer, description: String.t, min_order: float,
                         default_time: integer, default_charge_amount: float}
end
