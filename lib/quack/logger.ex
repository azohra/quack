defmodule Quack.Logger do
  @moduledoc false

  alias Quack.Duckling

  @behaviour :gen_event

  @doc false
  @impl :gen_event
  def init(__MODULE__) do
    {:ok, configure()}
  end

  @doc false
  @impl :gen_event
  def init({__MODULE__, level}) do
    {:ok, configure(level)}
  end

  @doc false
  @impl :gen_event
  def handle_call(_request, state) do
    {:ok, state, []}
  end

  @doc false
  @impl :gen_event
  def handle_info(_msg, state) do
    {:ok, state}
  end

  @doc false
  @impl :gen_event
  def handle_event(:flush, state) do
    {:ok, state}
  end

  @doc false
  @impl :gen_event
  def handle_event({lvl, _gl, {_, msg, ts, meta}}, state) do
    %{level: base_level, metadata: specified} = state

    params = {lvl, msg, ts, take_params(meta, specified)}

    if valid_priority(lvl, base_level), do: Duckling.quack(params)

    {:ok, state}
  end

  @doc false
  @impl :gen_event
  def terminate(_reason, _state) do
    :ok
  end

  # ----------HELPER FUNCTIONS----------#

  # Function to determine if the incoming event is of valid priority
  defp valid_priority(_incoming_level, nil), do: true

  defp valid_priority(incoming_level, base_level) do
    Logger.compare_levels(incoming_level, base_level) != :lt
  end

  # Function to configure the initial application state when the user specifies
  # the desired level in init/2
  defp configure(level) do
    meta = Application.get_env(:quack, :meta)

    %{
      level: level,
      metadata: meta
    }
  end

  # Function to configure the initial application state when init/1 is called
  defp configure do
    meta = Application.get_env(:quack, :meta)
    level = Application.get_env(:quack, :level)

    %{
      level: level,
      metadata: meta
    }
  end

  # Function that takes and stringifies the given params from a keyword list
  defp take_params(_data, :none), do: ""

  defp take_params(data, :all), do: format_keyword_list(data)
  defp take_params(data, nil), do: format_keyword_list(data)

  defp take_params(data, fields) do
    data
    |> Keyword.take(fields)
    |> format_keyword_list
  end

  # Helper function that stringifies each {key, val} in a keyword list
  defp format_keyword_list(list) do
    list
    |> Enum.reduce("", fn {k, v}, acc -> "#{k}: #{inspect(v)}\n" <> acc end)
  end
end
