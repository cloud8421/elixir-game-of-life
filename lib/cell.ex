defmodule Cell do
  defstruct x: nil, y: nil, status: nil

  def from_initial_value({status_int, x, y}) do
    %Cell{x: x, y: y, status: status_for(status_int)}
  end

  defp status_for(1), do: :alive
  defp status_for(0), do: :dead
end
