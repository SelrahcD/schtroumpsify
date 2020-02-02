defmodule Schtroumpsify.Tweet do
  defstruct id: 0, text: '', schtroumpsified_text: '', is_parsed: false, is_schtroumpsified: false, is_retweeted: false

  alias Schtroumpsify.Tweet

  def from(exTwitterTweet = %ExTwitter.Model.Tweet{}) do
    tweet = struct(Tweet, Map.from_struct(exTwitterTweet))
    events = [{:new_tweet, Map.from_struct(tweet)}]
    {:ok, tweet, events}
  end

  def from(tweetAsMap = %{}) do
    tweet = struct(Tweet, tweetAsMap)
    events = [{:new_tweet, Map.from_struct(tweet)}]
    {:ok, tweet, events}
  end

  def addNewText(tweet, schtroumpsifiedText) do
    newTweet = %Tweet{tweet | schtroumpsified_text: schtroumpsifiedText, is_schtroumpsified: true}
    events = [{:tweet_schtroumpsified, %{tweet_id: tweet.id, schtroumpsified_text: newTweet.schtroumpsified_text}}]
    {:ok, newTweet, events}
  end

  def markAsParsed(tweet) do
    newTweet = %Tweet{tweet | is_parsed: true}
    events = [{:tweet_parsed, %{tweet_id: tweet.id}}]
    {:ok, newTweet, events}
  end

  def markAsRetweeted(tweet) do
    newTweet = %Tweet{tweet | is_retweeted: true}
    events = [{:tweet_retweeted, %{tweet_id: tweet.id}}]
    {:ok, newTweet, events}
  end
end
