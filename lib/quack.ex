defmodule Quack do
  @moduledoc false

  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Quack.Duckling, [])
    ]

    opts = [strategy: :one_for_one, name: Quack.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
