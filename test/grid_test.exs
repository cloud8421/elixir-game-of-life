defmodule GridTest do
  use ExUnit.Case
  alias Grid, as: G
  @cells [
    [1,0,1],
    [0,1,0],
    [1,1,0]
  ]

  test "it parses a cell pattern and returns a grid" do
    grid = @cells |> G.parse_initial_values
    first_cell = grid |> List.first
    assert first_cell == %Cell{
      x: 0,
      y: 0,
      status: :alive
    }
    last_cell = grid |> List.last
    assert last_cell == %Cell{
      x: 2,
      y: 2,
      status: :dead
    }
  end

  test "transition to a new generation" do
    new_layout = [
      :dead,  :alive, :dead,
      :dead,  :dead,  :alive,
      :alive, :alive, :dead
    ]

    cells_status = @cells
    |> G.parse_initial_values
    |> G.transition_grid
    |> Enum.map(fn(x) -> x.status end)

    assert new_layout == cells_status
  end
end
