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

  def dimensions_from_initial_values(values) do
    width = values |> Enum.count
    height = values |> List.first |> Enum.count
    {width, height}
  end

  def transition_grid(grid) do
    Enum.map(grid, fn(cell) ->
      neighbours = neighbours(cell, grid)
      transition_cell(cell, neighbours)
    end)
  end

  defp neighbours(cell, grid) do
    Enum.filter(grid, fn(potential) ->
      Enum.member?(cell.x - 1..cell.x + 1, potential.x)
      && Enum.member?(cell.y - 1..cell.y + 1, potential.y)
      && cell != potential
    end)
  end

  defp count_alive(cells) do
    count_by_status(cells, :alive)
  end

  defp count_dead(cells) do
    count_by_status(cells, :dead)
  end

  defp count_by_status(cells, status) do
    cells
      |> Enum.filter(fn(n) -> n.status == status end)
      |> Enum.count
  end

  defp transition_cell(cell, neighbours) do
    updated_status = new_status_for(cell, neighbours)
    %Cell{cell | status: updated_status}
  end

  defp new_status_for(cell, neighbours) do
    new_status_for(cell.status, count_alive(neighbours), count_dead(neighbours))
  end

  defp new_status_for(:dead, 3, _dead_count), do: :alive
  defp new_status_for(:alive, live_count, _dead_count) when live_count > 3, do: :dead
  defp new_status_for(:alive, live_count, _dead_count) when live_count < 2, do: :dead
  defp new_status_for(status, _live_count, _dead_count), do: status
end
