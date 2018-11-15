defmodule Quack.Formatter do
  @moduledoc """
  Module responsible for formatting and composing messages to be sent to slack
  """

  import Logger.Formatter, only: [format_date: 1, format_time: 1]

  @doc """
  Function to compose a new message based on event data
  """
  def create_message({level, message, timestamp, ""}) do
    %{
      text: "*Incoming Log*",
      attachments: [
        %{
          author_name: "Quack - Elixir logging for Slack",
          author_link: "https://github.com/azohra/quack",
          color: get_colour(level),
          fields: [
            %{
              title: "Priority",
              value: Atom.to_string(level),
              short: false
            },
            %{
              title: "Timestamp",
              value: parse_ts(timestamp),
              short: false
            },
            %{
              title: "Message",
              value: to_preformatted(message)
            }
          ]
        }
      ]
    }
  end

  def create_message({level, message, timestamp, metadata}) do
    %{
      text: "*Incoming Log*",
      attachments: [
        %{
          author_name: "Quack - Elixir logging for Slack",
          author_link: "https://github.com/azohra/quack",
          color: get_colour(level),
          fields: [
            %{
              title: "Priority",
              value: Atom.to_string(level),
              short: false
            },
            %{
              title: "Timestamp",
              value: parse_ts(timestamp),
              short: false
            },
            %{
              title: "Metadata",
              value: metadata
            },
            %{
              title: "Message",
              value: to_preformatted(message)
            }
          ]
        }
      ]
    }
  end

  @doc """
  Function to format text as code

  iex> Quack.Formatter.to_code("example")
  "`example`"
  """
  def to_code(text), do: ~s(`#{text}`)

  @doc """
  Function to format text as preformatted

  iex> Quack.Formatter.to_preformatted("example")
  "```example```"
  """
  def to_preformatted(text), do: ~s(```#{text}```)

  @doc """
  Function to format text as bold

  iex> Quack.Formatter.to_bold("example")
  "*example*"
  """
  def to_bold(text), do: ~s(*#{text}*)

  @doc """
  Function to format text as italics

  iex> Quack.Formatter.to_italics("example")
  "_example_"
  """
  def to_italics(text), do: ~s(_#{text}_)

  @doc """
  Function to format text as a quote

  iex> Quack.Formatter.to_quote("example")
  ">example"
  """
  def to_quote(text), do: ~s(>#{text})

  @doc """
  Function to format a timestamp as a string

  iex>Quack.Formatter.parse_ts({{2018, 11, 5}, {15, 4, 46, 613}})
  "2018-11-05 15:04:46.613"
  """
  def parse_ts({date, time}) do
    d =
      date
      |> format_date()
      |> to_string()

    t =
      time
      |> format_time
      |> to_string

    d <> " " <> t
  end

  # Function to return a colour based on logger level
  defp get_colour(:debug), do: "#9215E8"
  defp get_colour(:info), do: "#00B4FF"
  defp get_colour(:warn), do: "#E8BD08"
  defp get_colour(:error), do: "#FF3B0A"
end
