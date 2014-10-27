defmodule GridTest do
  use ExUnit.Case
  @cells [
    [1,0,1],
    [1,1,1]
  ]

  setup do
    Grid.start_link(@cells)
    :ok
  end

  test "it receives a nested list of cells" do
    first_cell = Grid.cells |> List.first
    assert first_cell == %Cell{
      x: 0,
      y: 0,
      status: :alive
    }
    last_cell = Grid.cells |> List.last
    assert last_cell == %Cell{
      x: 2,
      y: 1,
      status: :alive
    }
  end

end
