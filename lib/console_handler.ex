defmodule ConsoleHandler do
  use GenEvent

  def handle_event({:update, cells}, dimensions = [width: width, height: height]) do
    clear
    generate_grid(width, height, cells)
    {:ok, dimensions}
  end

  defp generate_grid(width, height, cells) do
    print_header(width)
    print_cells(height, cells)
    print_footer(width)
  end

  defp print_cells(height, cells) do
    cells
      |> Enum.chunk(height)
      |> Enum.map(fn(group) ->
           print_left_border
           for cell <- group, do: print_cell(cell.status)
           print_right_border
         end)
  end

  defp print_header(size) do
    IO.write "⌈"
    String.duplicate("---", size)
    |> IO.write
    IO.puts "⌉"
  end

  defp print_footer(size) do
    IO.write "⌊"
    String.duplicate("---", size)
    |> IO.write
    IO.puts "⌋"
  end

  defp print_left_border do
    IO.write "|"
  end

  defp print_right_border do
    IO.puts "|"
  end

  defp print_cell(:dead) do
    IO.write " ◻︎ "
  end

  defp print_cell(:alive) do
    IO.write " ◼︎ "
  end

  # taken from https://github.com/tomgco/elixir-charm/blob/master/lib/charm.ex#L102-L106
  def clear do
    IO.write IO.ANSI.format [ "\e[0m" ]
    IO.write IO.ANSI.format [ "\e[2J" ]
    IO.write IO.ANSI.format [ "\ec" ]
  end

end
