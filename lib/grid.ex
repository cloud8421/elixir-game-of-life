defmodule Grid do
  use GenServer
  alias GridRules, as: GR

  @refresh_interval 1000

  def cells do
    GenServer.call(__MODULE__, :cells)
  end

  def tick do
    GenServer.cast(__MODULE__, :tick)
  end

  ## Callbacks

  def start_link(initial_values) do
    GenServer.start_link(__MODULE__, initial_values, name: __MODULE__)
  end

  def init(initial_values) do
    {:ok, dispatcher} = GenEvent.start_link
    GenEvent.add_handler(dispatcher, ConsoleHandler, [])
    grid = initial_values |> parse_initial_values
    GenEvent.notify(dispatcher, {:update, grid})
    {:ok, {grid, dispatcher}, @refresh_interval}
  end

  def handle_call(:cells, _from, state = {grid, _dispatcher}) do
    {:reply, grid, state}
  end

  def handle_cast(:tick, {grid, dispatcher}) do
    new_grid = Enum.map(grid, fn(cell) ->
      neighbours = GR.neighbours(cell, grid)
      transition(cell, neighbours)
    end)
    GenEvent.notify(dispatcher, {:update, new_grid})
    {:noreply, {new_grid, dispatcher}, @refresh_interval}
  end

  def handle_info(:timeout, state) do
    Grid.tick
    {:noreply, state}
  end

  ## Private

  defp transition(cell, grid) do
    updated_status = GR.new_status_for(cell, grid)
    %Cell{cell | status: updated_status}
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
