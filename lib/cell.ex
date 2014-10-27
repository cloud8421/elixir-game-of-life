defmodule Cell do
  defstruct x: nil, y: nil, status: nil

  def from_initial_value({0, x, y}) do
    %Cell{x: x, y: y, status: :dead}
  end
  def from_initial_value({1, x, y}) do
    %Cell{x: x, y: y, status: :alive}
  end
end
