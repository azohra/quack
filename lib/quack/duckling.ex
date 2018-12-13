defmodule Quack.Duckling do
  @moduledoc false

  use GenServer

  alias Quack.Messenger

  @doc false
  def start_link do
    webhook = Application.get_env(:quack, :webhook_url)
    GenServer.start_link(__MODULE__, webhook, name: __MODULE__)
  end

  @doc false
  @impl true
  def init(url) do
    {:ok, url}
  end

  @doc false
  def quack(message) do
    GenServer.cast(__MODULE__, {:send, message})
  end

  @doc false
  @impl true
  def handle_cast({:send, event}, url) do
    Messenger.send(url, event)

    {:noreply, url}
  end
end
