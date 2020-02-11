require Logger

defmodule Schtroumpsify.TweetParser do
  @moduledoc false

  alias Schtroumpsify.Tweet
  alias Schtroumpsify.FlowRunner

  def parse(%{tweet: tweet} = flow) do
    Logger.debug("Parsing #{tweet.id} #{tweet.text}")

    preparedSentence = tweet.text
    |> String.replace("|", "")
    |> String.replace(~r( ?https?://[^\s]+), "")
    |> String.replace(~r/ ?\[.+\]/, "")

    Logger.info("Prepared sentence #{tweet.id} #{preparedSentence}")

    response = HTTPoison.post!(Application.fetch_env!(:schtroumpsify, :frmg)[:url], {:form, [sentence: preparedSentence]}, [timeout: 10000, recv_timeout: :infinity])

    Logger.info("Parsing result #{tweet.id} #{response.body}")

    flow
    |> Map.put(:parsing, Poison.decode!(response.body)["data"])
    |> FlowRunner.add_to_flow(Tweet.markAsParsed(tweet))
  end
end
