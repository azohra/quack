defmodule Quack.Duckling do
  @moduledoc false

  use GenServer

  alias Quack.{Formatter, Messenger}

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
  def quack(message) do
    GenServer.call(__MODULE__, {:send, message})
  end

  @doc false
  @impl true
  def handle_call({:send, event}, _from, state) do
    event
    |> Formatter.create_message()
    |> Poison.encode!()
    |> Messenger.send()

    {:reply, :ok, state}
  end
end
