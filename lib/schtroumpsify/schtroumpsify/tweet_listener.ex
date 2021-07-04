require Logger

defmodule Schtroumpsify.TweetListener do
  @moduledoc false
  use GenServer
  alias Schtroumpsify.FlowsSupervisor

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_printer_pid) do
    {:ok, nil, {:continue, :listen}}
  end

  def handle_continue(:listen, state) do

    Logger.debug("Start listening...")

    ExTwitter.stream_filter([follow: "24744541"], :infinity)
    |> Stream.filter(fn tweet -> tweet.user.id == 24744541 && is_nil(tweet.retweeted_status) end)
    |> Stream.map(fn tweet ->
      Logger.info("New tweet #{tweet.id} #{tweet.full_text}")
      tweet
    end)
    |> Stream.map(&FlowsSupervisor.startFlow/1)
    |> Stream.run()


    {:noreply, state, {:continue, :listen}}
  end

  def child_spec(_arg) do
    %{
      id: TweetListener,
      start: {__MODULE__, :start_link, []}
    }
  end

end
