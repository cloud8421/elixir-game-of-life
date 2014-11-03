defmodule Grid do
  # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  # Any live cell with two or three live neighbours lives on to the next generation.
  # Any live cell with more than three live neighbours dies, as if by overcrowding.
  # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

  def parse_initial_values(values) do
    values
    |> Enum.with_index
    |> Enum.flat_map(fn({row, y}) ->
      row
      |> Enum.with_index
      |> Enum.map(fn({status, x}) ->
        Cell.from_initial_value({status, x, y})
      end)
    end)
  end

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

  def transition_grid(grid) do
    Enum.map(grid, fn(cell) ->
      neighbours = neighbours(cell, grid)
      transition_cell(cell, neighbours)
    end)
  end

  def transition_cell(cell, neighbours) do
    updated_status = new_status_for(cell, neighbours)
    %Cell{cell | status: updated_status}
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
