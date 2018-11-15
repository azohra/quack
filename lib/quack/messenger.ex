defmodule Quack.Messenger do
  @moduledoc false
  use Tesla

  plug(Tesla.Middleware.Headers, [{"content-type", "application/json"}])

  @doc """
  Function to send message to slack webhook
  """
  def send(msg) do 
    webhook = Application.get_env(:quack, :webhook_url)
    post(webhook, msg)
  end
end
