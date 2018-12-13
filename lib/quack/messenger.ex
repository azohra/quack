defmodule Quack.Messenger do
  @moduledoc false
  use Tesla

  plug(Tesla.Middleware.Headers, [{"content-type", "application/json"}])

  @doc """
  Function to send message to slack webhook
  """
  def send(url, msg) do
    post(url, msg)
  end
end
