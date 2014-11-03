defmodule GridRules do

  # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  # Any live cell with two or three live neighbours lives on to the next generation.
  # Any live cell with more than three live neighbours dies, as if by overcrowding.
  # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

  def neighbours(cell, grid) do
    Enum.filter(grid, fn(potential) ->
      Enum.member?(cell.x - 1..cell.x + 1, potential.x)
      && Enum.member?(cell.y - 1..cell.y + 1, potential.y)
      && cell != potential
    end)
  end

  def count_alive(cells) do
    cells
      |> Enum.filter(fn(n) -> n.status == :alive end)
      |> Enum.count
  end

  def count_dead(cells) do
    cells
      |> Enum.filter(fn(n) -> n.status == :dead end)
      |> Enum.count
  end

  def new_status_for(cell, neighbours) do
    new_status_for(cell.status, count_alive(neighbours), count_dead(neighbours))
  end

  defp new_status_for(:dead, 3, _dead_count), do: :alive
  defp new_status_for(:alive, live_count, _dead_count) when live_count > 3, do: :dead
  defp new_status_for(:alive, live_count, _dead_count) when live_count < 2, do: :dead
  defp new_status_for(:alive, _live_count, _dead_count), do: :alive
  defp new_status_for(:dead, _live_count, _dead_count), do: :dead
end
