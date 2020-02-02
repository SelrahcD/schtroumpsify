require Logger
defmodule Schtroumpsify.TweetStatesServer do
  @moduledoc false

  use GenServer
  alias Schtroumpsify.TweetCollection

  def start_link() do
    Logger.debug('TweetStates starting...')
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    {:ok, TweetCollection.new()}
  end

  def listAll() do
    GenServer.call(__MODULE__, :list_all)
  end

  def takeLast(amount) do
    Logger.debug("take last")
    GenServer.call(__MODULE__, {:take, amount})
  end

  def modify(tweet) do
    GenServer.call(__MODULE__, {:modify, tweet})
  end

  def handle_call(:list_all, _from, tweets) do
    {:reply, TweetCollection.listAll(tweets), [], tweets}
  end

  def handle_call({:take, amount}, _from, tweets) do
    {:reply, TweetCollection.take(tweets, amount), tweets}
  end

  def handle_call({:modify, tweet}, _from, tweets) do
    {:ok, newTweets} = TweetCollection.updateTweet(tweets, tweet)
    {:reply, :ok, newTweets}
  end

  def child_spec(_arg) do
    %{
      id: TweetStates,
      start: {__MODULE__, :start_link, []}
    }
  end

end
