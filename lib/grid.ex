defmodule Grid do
  use GenServer

  def cells do
    GenServer.call(__MODULE__, :cells)
  end

  ## Callbacks

  def start_link(initial_values) do
    GenServer.start_link(__MODULE__, initial_values, name: __MODULE__)
  end

  def init(initial_values) do
    {:ok, initial_values |> parse_initial_values}
  end

  def handle_call(:cells, _from, state) do
    {:reply, state, state}
  end

  ## Private

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
