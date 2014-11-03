defmodule GridWorker do
  use GenServer
  alias Grid, as: G

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
    grid = initial_values |> G.parse_initial_values
    GenEvent.notify(dispatcher, {:update, grid})
    {:ok, {grid, dispatcher}, @refresh_interval}
  end

  def handle_call(:cells, _from, state = {grid, _dispatcher}) do
    {:reply, grid, state}
  end

  def handle_cast(:tick, {grid, dispatcher}) do
    new_grid = G.transition_grid(grid)
    GenEvent.notify(dispatcher, {:update, new_grid})
    {:noreply, {new_grid, dispatcher}, @refresh_interval}
  end

  def handle_info(:timeout, state) do
    tick
    {:noreply, state}
  end
end
