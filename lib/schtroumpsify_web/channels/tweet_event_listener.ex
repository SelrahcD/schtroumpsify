require Logger

defmodule SchtroumpsifyWeb.TweetEventListener do
  @moduledoc false

  use GenStage

  def start_link() do
    Logger.debug('Tweet events listener starting...')
    GenStage.start_link(__MODULE__, [], name: SchtroumpsifyWeb.TweetEventListener)
  end

  def init(args) do
    {:consumer, :the_state_does_not_matter, subscribe_to: [Schtroumpsify.TweetStatesServer]}
  end

  def handle_events(events, _from, state) do
    Logger.debug("New events")

    for event <- events do
      case event do
        {:new_tweet, content} -> SchtroumpsifyWeb.Endpoint.broadcast!("tweets", "new_tweet", %{body: content})
      end
    end

    {:noreply, [], state}
  end

  def child_spec(arg) do
    %{
      id: TweetEventListener,
      start: {__MODULE__, :start_link, []}
    }
  end

end
