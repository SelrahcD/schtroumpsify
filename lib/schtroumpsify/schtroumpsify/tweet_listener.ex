require Logger

defmodule Schtroumpsify.TweetListener do
  @moduledoc false
  use GenServer
  alias Schtroumpsify.FlowsSupervisor

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_printer_pid) do
    startListening()
    {:ok, nil}
  end

  def startListening() do
    GenServer.cast(self(), :start_listening)
  end

  def handle_cast(:start_listening, state) do

    Logger.debug("Start listening...")

    listen()

    {:noreply, state}
  end

  def child_spec(_arg) do
    %{
      id: TweetListener,
      start: {__MODULE__, :start_link, []}
    }
  end

  defp listen do

    ExTwitter.stream_filter([follow: "24744541"], :infinity)
    |> Stream.filter(fn tweet -> tweet.user.id == 24744541 end)
    |> Stream.map(fn tweet ->
      Logger.info("New tweet #{tweet.id} #{tweet.full_text}")
      tweet
    end)
    |> Stream.map(&FlowsSupervisor.startFlow/1)
    |> Stream.run()

    listen()
  end

end
