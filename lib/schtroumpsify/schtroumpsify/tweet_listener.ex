require Logger

defmodule Schtroumpsify.TweetListener do
  @moduledoc false
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_printer_pid) do
    startListening()
    {:ok, nil}
  end

  def startListening() do
    GenServer.cast(self, :start_listening)
  end

  def handle_cast(:start_listening, state) do

    Logger.debug("Start listening...")

    ExTwitter.stream_filter(follow: "24744541")
#        |> Stream.filter(fn tweet -> tweet.user.id == 24744541 && tweet.retweeted_status == nil end)
        |> Stream.map(&Schtroumpsify.FlowsSupervisors.startFlow/1)
#        |> Stream.filter(fn tweet -> Schtroumpsify.TweetStates.addTweet(tweet.text) end)
          #    |> Stream.map(fn x -> %IncomingTweet{id: x.id, content: x.text} end)
          #    |> Stream.map(fn x -> Schtroumpsify.FlowSupervisor.startFlow end)
        |> Stream.run()

    {:no_reply, state, state}
  end

  def child_spec(_arg) do
    %{
      id: TweetListener,
      start: {__MODULE__, :start_link, []}
    }
  end

end
