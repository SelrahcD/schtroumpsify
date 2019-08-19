require Logger

defmodule Schtroumpsify.TweetListener do
  @moduledoc false
  use GenServer
  alias Schtroumpsify.FlowsSupervisors

  def start_link() do
    GenServer.start_link(__MODULE__, [])
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

    ExTwitter.stream_filter(follow: "24744541")
        |> Stream.map(&FlowsSupervisors.startFlow/1)
        |> Stream.run()

    {:noreply, state}
  end

  def child_spec(_arg) do
    %{
      id: TweetListener,
      start: {__MODULE__, :start_link, []}
    }
  end

end
