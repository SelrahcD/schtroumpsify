defmodule SchtroumpsifyWeb.TweetChannel do
  @moduledoc false

  use Phoenix.Channel

  def join("tweets", _message, socket) do
    {:ok, socket}
  end

end
