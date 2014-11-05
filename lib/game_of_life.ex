defmodule GameOfLife do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    initial_layout = [
      [1,0,1,1,0,1],
      [0,1,0,1,0,1],
      [1,1,0,1,0,1],
      [1,0,1,1,0,1],
      [0,1,0,1,0,1],
      [1,0,1,1,0,1]
    ]

    children = [
      worker(GridWorker, [initial_layout])
    ]

    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
