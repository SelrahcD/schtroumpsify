require Logger
defmodule SchtroumpsifyWeb.PageController do
  use SchtroumpsifyWeb, :controller

  def index(conn, _params) do
    tweets = Schtroumpsify.TweetStatesServer.takeLast(5)

    IO.inspect(tweets)

    render(conn, "index.html",tweets: tweets)
  end
end
