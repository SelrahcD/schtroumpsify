defmodule Schtroumpsify.FlowRunner do
  @moduledoc false

  use GenServer
  alias Schtroumpsify.TweetStatesServer
  alias Schtroumpsify.Tweet

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
    TweetStatesServer.addUsing(fn -> Tweet.from(tweet) end)
    Process.sleep(1000)
    TweetStatesServer.modify(tweet, &Tweet.markAsParsed(&1))
    Process.sleep(1000)
    TweetStatesServer.modify(tweet, &Tweet.addNewText(&1, "YOLO"))
    Process.sleep(1000)
    TweetStatesServer.modify(tweet, &Tweet.markAsRetweeted(&1))

    {:stop, :normal, state}
  end

end
