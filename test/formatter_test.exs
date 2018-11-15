defmodule FormatterTest do
  @moduledoc false

  use ExUnit.Case
  alias Quack.Formatter

  doctest Quack.Formatter

  @message %{
    attachments: [
      %{
        author_link: "https://github.com/MatthewNielsen27/quack",
        author_name: "Quack - Elixir logging for Slack",
        color: "#00B4FF",
        fields: [
          %{
            short: false,
            title: "Priority",
            value: "info"
          },
          %{
            short: false,
            title: "Timestamp",
            value: "2018-11-05 15:04:46.613"
          },
          %{
            title: "Message",
            value: "```sample_message```"
          }
        ]
      }
    ],
    text: "*Incoming Log*"
  }

  @message_with_meta %{
    attachments: [
      %{
        author_link: "https://github.com/MatthewNielsen27/quack",
        author_name: "Quack - Elixir logging for Slack",
        color: "#00B4FF",
        fields: [
          %{
            short: false,
            title: "Priority",
            value: "info"
          },
          %{
            short: false,
            title: "Timestamp",
            value: "2018-11-05 15:04:46.613"
          },
          %{
            title: "Metadata",
            value: "line: 17"
          },
          %{
            title: "Message",
            value: "```sample_message```"
          }
        ]
      }
    ],
    text: "*Incoming Log*"
  }

  test "properly format as bold" do
    assert Formatter.to_bold("test") == "*test*"
  end

  test "properly format as italics" do
    assert Formatter.to_italics("test") == "_test_"
  end

  test "properly format as code" do
    assert Formatter.to_code("test") == "`test`"
  end

  test "properly format as preformatted text" do
    assert Formatter.to_preformatted("test") == "```test```"
  end

  test "properly format as a quote" do
    assert Formatter.to_quote("test") == ">test"
  end

  test "properly parse a time signature" do
    ts = {{2018, 11, 5}, {15, 4, 46, 613}}

    assert Formatter.parse_ts(ts) == "2018-11-05 15:04:46.613"
  end

  test "message composition" do
    assert Formatter.create_message(
             {:info, "sample_message", {{2018, 11, 5}, {15, 4, 46, 613}}, ""}
           ) == @message

    assert Formatter.create_message(
             {:info, "sample_message", {{2018, 11, 5}, {15, 4, 46, 613}}, "line: 17"}
           ) == @message_with_meta
  end
end
