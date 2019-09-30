require Logger

defmodule SchtroumpsifyWeb.TweetEventListener do
  @moduledoc false

  use GenStage

  def start_link(_args) do
    Logger.debug('Tweet events listener starting...')
    GenStage.start_link(__MODULE__, [], name: SchtroumpsifyWeb.TweetEventListener)
  end

  def init(_args) do
    {:consumer, :the_state_does_not_matter, subscribe_to: [Schtroumpsify.TweetStatesServer]}
  end

  def handle_events(events, _from, state) do

    for event <- events do
      case event do
        {eventName, data} -> SchtroumpsifyWeb.Endpoint.broadcast!("tweets", Atom.to_string(eventName), data)
      end
    end

    {:noreply, [], state}
  end

  def child_spec() do
    %{
      id: TweetEventListener,
      start: {__MODULE__, :start_link}
    }
  end

end
