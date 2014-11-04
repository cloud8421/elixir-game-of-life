defmodule GridWorker do
  use GenServer
  alias Grid, as: G

  defmodule WorkerState do
    defstruct cells: [], dispatcher: nil
  end

  @refresh_interval 1000

  def tick do
    GenServer.cast(__MODULE__, :tick)
  end

  ## Callbacks

  def start_link(initial_values) do
    GenServer.start_link(__MODULE__, initial_values, name: __MODULE__)
  end

  def init(initial_values) do
    state = build_initial_state(initial_values)
    {width, height} = dimensions_for(initial_values)
    GenEvent.add_handler(state.dispatcher,
                         ConsoleHandler,
                         [width: width, height: height])
    GenEvent.notify(state.dispatcher, {:update, state.cells})
    {:ok, state, @refresh_interval}
  end

  def handle_cast(:tick, state = %WorkerState{cells: grid, dispatcher: dispatcher}) do
    new_grid = G.transition_grid(grid)
    new_state = %WorkerState{state | cells: new_grid}
    GenEvent.notify(dispatcher, {:update, new_grid})
    {:noreply, new_state, @refresh_interval}
  end

  def handle_info(:timeout, state) do
    tick
    {:noreply, state}
  end

  ## Private

  defp dimensions_for(initial_values) do
    width = initial_values |> Enum.count
    height = initial_values |> List.first |> Enum.count
    {width, height}
  end

  defp build_initial_state(initial_values) do
    cells = initial_values |> G.parse_initial_values
    {:ok, dispatcher} = GenEvent.start_link
    %WorkerState{cells: cells, dispatcher: dispatcher}
  end
end
