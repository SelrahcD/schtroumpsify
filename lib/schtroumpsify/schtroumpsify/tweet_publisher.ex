
defmodule Schtroumpsify.TweetPublisher do
  @moduledoc false

  alias Schtroumpsify.Tweet
  alias Schtroumpsify.FlowRunner

  def publish(%{tweet: tweet} = flow) do

    ExTwitter.update(tweet.schtroumpsified_text)

    flow
    |> FlowRunner.add_to_flow(Tweet.markAsRetweeted(tweet))
  end

end
