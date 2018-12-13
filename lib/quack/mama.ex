defmodule Quack.Mama do
  @moduledoc false

  use GenServer

  alias Quack.Duckling
  alias Quack.Formatter

  @doc false
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc false
  @impl true
  def init(state) do
    {:ok, state}
  end

  @doc false
  def process(message) do
    GenServer.cast(__MODULE__, {:send, message})
  end

  @doc false
  @impl true
  def handle_cast({:send, event}, state) do
    event
    |> Formatter.create_message()
    |> Poison.encode!()
    |> Duckling.quack()

    {:noreply, state}
  end
end