require Logger

defmodule Schtroumpsify.FlowRunner do
  @moduledoc false

  use GenServer
  alias Schtroumpsify.TweetStatesServer
  alias Schtroumpsify.Tweet
  alias Schtroumpsify.TweetParser
  alias Schtroumpsify.TweetTransformer
  alias Schtroumpsify.TweetPublisher

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet)
  end

  @impl true
  def init(tweet) do
    {:ok, nil, {:continue, {:compute_tweet, tweet}}}
  end

  @impl true
  def handle_continue({:compute_tweet, tweet}, state) do

    %{events: [], tweet: nil}
    |> add_to_flow(Tweet.from(tweet))
    |> save_and_dispatch_event()
    |> TweetParser.parse()
    |> save_and_dispatch_event()
    |> TweetTransformer.transform()
    |> save_and_dispatch_event()
    |> TweetPublisher.publish()
    |> save_and_dispatch_event()

    {:stop, :normal, state}
  end


  def add_to_flow(flow, {:ok, tweet, events}) do
    flow
    |> Map.put(:tweet, tweet)
    |> Map.put(:events, events)
  end

  defp save_and_dispatch_event(%{events: events, tweet: tweet} = result) do

    TweetStatesServer.modify(tweet)

    for event <- events do
      case event do
        {eventName, data} -> SchtroumpsifyWeb.Endpoint.broadcast!("tweets", Atom.to_string(eventName), data)
      end
    end

    result
  end

end
