defmodule ConsoleHandler do
  use GenEvent

  def handle_event({:update, cells}, dimensions = [width: width, height: height]) do
    clear
    generate_grid(width, height, cells)
    {:ok, dimensions}
  end

  defp generate_grid(width, height, cells) do
    print_header(width - 1)
    cells
      |> Enum.chunk(height)
      |> Enum.map(fn(group) ->
           print_left_border
           Enum.map(group, fn(cell) ->
             print_cell(cell.status)
           end)
           print_right_border
         end)
    print_footer(width - 1)
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

  # taken from https://github.com/tomgco/elixir-charm/blob/master/lib/charm.ex#L102-L106
  def clear do
    IO.write IO.ANSI.format [ "\e[0m" ]
    IO.write IO.ANSI.format [ "\e[2J" ]
    IO.write IO.ANSI.format [ "\ec" ]
  end

end
