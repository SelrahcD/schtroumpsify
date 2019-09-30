defmodule SchtroumpsifyWeb.TweetChannel do
  @moduledoc false

  use Phoenix.Channel

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def join("tweets", _message, socket) do
    {:ok, socket}
  end

end
