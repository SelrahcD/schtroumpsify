defmodule Schtroumpsify.FlowRunner do
  @moduledoc false

  use GenServer
  alias Schtroumpsify.TweetStatesServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet)
  end

  @impl true
  def init(tweet) do
    compute_tweet(tweet)
    {:ok, %{tweet: tweet}}
  end

  def compute_tweet(tweet) do
    GenServer.cast(self(), {:compute_tweet, tweet})
  end

  @impl true
  def handle_cast({:compute_tweet, tweet}, state) do
    TweetStatesServer.addTweet(tweet.text)
    {:noreply, state}
  end

end
