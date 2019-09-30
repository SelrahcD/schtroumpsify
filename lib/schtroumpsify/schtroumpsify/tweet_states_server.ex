require Logger
defmodule Schtroumpsify.TweetStatesServer do
  @moduledoc false

  use GenStage
  alias Schtroumpsify.TweetCollection

  def start_link(tweetCollection, events) do
    Logger.debug('TweetStates starting...')
    IO.inspect(tweetCollection)
    GenStage.start_link(__MODULE__, %{tweets: tweetCollection, events: events}, name: __MODULE__, dispatcher: GenStage.BroadcastDispatcher)
  end

  def init(init_arg) do
    {:producer, init_arg}
  end

  def listAll() do
    GenServer.call(__MODULE__, :list_all)
  end

  def takeLast(amount) do
    GenServer.call(__MODULE__, {:take, amount})
  end

  def modify(tweet, updateFn) do
    GenServer.call(__MODULE__, {:modify, tweet, updateFn})
  end

  def addUsing(creationFn) do
    GenServer.call(__MODULE__, {:add_using, creationFn})
  end

  def handle_call(:list_all, _from, state) do
    IO.inspect(state.tweets)
    {:reply, TweetCollection.listAll(state.tweets), [], state}
  end

  def handle_call({:take, amount}, _from, state) do
    {:reply, TweetCollection.take(state.tweets, amount), [], state}
  end

  def handle_call({:add_using, creationFn}, _from, state) do
    {:ok, newTweets, events} = TweetCollection.addTweet(state.tweets, creationFn)
    newState = %{state | tweets: newTweets}
    {:reply, :ok, events, newState}
  end

  def handle_call({:modify, tweet, updateFn}, _from, state) do
    {:ok, newTweets, events} = TweetCollection.updateTweet(state.tweets, tweet.id, updateFn)
    newState = %{state | tweets: newTweets}
    {:reply, :ok, events, newState}
  end

  def handle_demand(demand, state) do
    IO.inspect(demand)
    {:noreply, [], state}
  end

  def child_spec(_arg) do
    %{
      id: TweetStates,
      start: {__MODULE__, :start_link, [TweetCollection.new(), []]}
    }
  end

end
