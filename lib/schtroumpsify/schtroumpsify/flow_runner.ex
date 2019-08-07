defmodule Schtroumpsify.FlowRunner do
  @moduledoc false

  use GenServer

  def start_link(tweet) do
    GenServer.start_link(__MODULE__, tweet)
  end

  @impl true
  def init(tweet) do
    IO.inspect(tweet)
    {:ok, %{tweet: tweet}}
  end

end
