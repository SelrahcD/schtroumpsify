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

  def handle_call(:list_all, _from, state) do
    IO.inspect(state)
    {:reply, TweetCollection.listAll(state.tweets), [], state}
  end

  def handle_cast({:add, content}, state) do
    event = {:new_tweet, content}
    IO.inspect(event)
    {:noreply, [event], %{state | tweets: TweetCollection.addTweet(state.tweets, content)}}
  end

  def listAll() do
    GenServer.call(__MODULE__, :list_all)
  end

  def addTweet(content) do
    GenServer.cast(__MODULE__, {:add, content})
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
