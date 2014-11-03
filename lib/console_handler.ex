defmodule ConsoleHandler do
  use GenEvent

  def handle_event({:update, grid}, []) do
    Charm.reset
    generate_grid(grid)
    {:ok, []}
  end

  defp grid_to_dimensions(grid) do
    grid
      |> Enum.count
      |> :math.sqrt
      |> trunc
  end

  defp generate_grid(grid) do
    size = grid_to_dimensions(grid)
    print_header(size - 1)
    grid
      |> Enum.chunk(size)
      |> Enum.map(fn(group) ->
           print_left_border
           Enum.map(group, fn(cell) ->
             print_cell(cell.status)
           end)
           print_right_border
         end)
    print_footer(size - 1)
  end

  defp print_header(size) do
    IO.write "⌈"
    Enum.map(0..size, fn(_x) ->
      IO.write "⎯⎯⎯"
    end)
    IO.puts "⌉"
  end

  defp print_footer(size) do
    IO.write "⌊"
    Enum.map(0..size, fn(_x) ->
      IO.write "⎯⎯⎯"
    end)
    IO.puts "⌋"
  end

  defp print_left_border do
    IO.write "|"
  end

  defp print_right_border do
    IO.puts "|"
  end

  defp print_cell(:dead) do
    IO.write " "
    IO.write "◻︎"
    IO.write " "
  end

  defp print_cell(:alive) do
    IO.write " "
    IO.write "◼︎"
    IO.write " "
  end

end
