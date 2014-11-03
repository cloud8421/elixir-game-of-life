defmodule GameOfLife do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
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
      # Define workers and child supervisors to be supervised
      # worker(GameOfLife.Worker, [arg1, arg2, arg3])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
