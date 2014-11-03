defmodule GridTest do
  use ExUnit.Case
  @cells [
    [1,0,1],
    [0,1,0],
    [1,1,0]
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
      y: 2,
      status: :dead
    }
  end

  test "state transitions" do
    Grid.tick

    new_layout = [
      :dead,  :alive, :dead,
      :dead,  :dead,  :alive,
      :alive, :alive, :dead
    ]

    cells_status = Grid.cells |> Enum.map(fn(x) -> x.status end)

    assert new_layout == cells_status
  end
end
