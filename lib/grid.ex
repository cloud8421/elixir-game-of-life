defmodule Grid do
  use GenServer

  def cells do
    GenServer.call(__MODULE__, :cells)
  end

  def neighbours(cell) do
    GenServer.call(__MODULE__, {:neighbours, cell})
  end

  ## Callbacks

  def start_link(initial_values) do
    GenServer.start_link(__MODULE__, initial_values, name: __MODULE__)
  end

  def init(initial_values) do
    {:ok, initial_values |> parse_initial_values}
  end

  def handle_call(:cells, _from, grid) do
    {:reply, grid, grid}
  end

  def handle_call({:neighbours, cell}, _from, grid) do
    neighbours = neighbours_for(cell, grid)
    {:reply, neighbours, grid}
  end

  ## Private

  defp neighbours_for(cell, grid) do
    Enum.filter(grid, fn(potential) ->
      Enum.member?(cell.x - 1..cell.x + 1, potential.x)
      && Enum.member?(cell.y - 1..cell.y + 1, potential.y)
      && cell != potential
    end)
  end

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
end
