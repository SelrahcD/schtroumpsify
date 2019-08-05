require Logger
defmodule Schtroumpsify.TweetStates do
  @moduledoc false

  use GenStage

  def start_link(tweets, events) do
    Logger.debug('TweetStates starting...')
    GenStage.start_link(__MODULE__, %{tweets: tweets, events: events}, name: Schtroumpsify.TweetStates, dispatcher: GenStage.BroadcastDispatcher)
  end

  def init(init_arg) do
    {:producer, init_arg}
  end

  def handle_call(:list_all, _from, state) do
    {:reply, state.tweets, [], state}
  end

  def handle_cast({:add, content}, state) do
    event = {:new_tweet, content}
    IO.inspect(event)
    {:noreply, [event], %{tweets: [content] ++ state.tweets}}
  end

  def listAll() do
    GenServer.call(Schtroumpsify.TweetStates, :list_all)
  end

  def addTweet(content) do
    GenServer.cast(Schtroumpsify.TweetStates, {:add, content})
  end

  def handle_demand(demand, state) do
    {:noreply, [], state}
  end

  def child_spec(arg) do
    %{
      id: TweetStates,
      start: {__MODULE__, :start_link, [[], []]}
    }
  end

end
