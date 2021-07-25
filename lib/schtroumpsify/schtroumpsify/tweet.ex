defmodule Schtroumpsify.Tweet do
  defstruct id: 0, text: '', schtroumpsified_text: '', is_parsed: false, is_schtroumpsified: false, is_retweeted: false

  @type t :: %__MODULE__{
              id: integer,
              text: String.t,
              schtroumpsified_text: String.t,
              is_parsed: boolean,
              is_schtroumpsified: boolean,
              is_retweeted: boolean
             }

  @type result :: positive_result
  @type positive_result :: {:ok, t, [event]}
  @type event :: {event_name, event_data}

  @type event_name :: atom()
  @type event_data :: map()

  alias Schtroumpsify.Tweet

  @spec from(ExTwitter.Model.Tweet.t) :: result
  def from(exTwitterTweet = %ExTwitter.Model.Tweet{}) do

    text = case exTwitterTweet.raw_data do
      %{extended_tweet: extended_tweet} -> extended_tweet.full_text
      _ -> exTwitterTweet.raw_data.text
    end

    tweet = %Tweet{id: exTwitterTweet.id, text: text}

    events = [{:new_tweet, Map.from_struct(tweet)}]
    {:ok, tweet, events}
  end

  @spec from(%{text: String.t}) :: result
  def from(tweetAsMap = %{}) do
    tweet = struct(Tweet, tweetAsMap)

    events = [{:new_tweet, Map.from_struct(tweet)}]
    {:ok, tweet, events}
  end

  @spec addNewText(t, String.t) :: result
  def addNewText(tweet, schtroumpsifiedText) do
    newTweet = %Tweet{tweet | schtroumpsified_text: schtroumpsifiedText, is_schtroumpsified: true}
    events = [{:tweet_schtroumpsified, %{tweet_id: tweet.id, schtroumpsified_text: newTweet.schtroumpsified_text}}]
    {:ok, newTweet, events}
  end

  @spec markAsParsed(t) :: result
  def markAsParsed(tweet) do
    newTweet = %Tweet{tweet | is_parsed: true}
    events = [{:tweet_parsed, %{tweet_id: tweet.id}}]
    {:ok, newTweet, events}
  end

  @spec markAsRetweeted(t) :: result
  def markAsRetweeted(tweet) do
    newTweet = %Tweet{tweet | is_retweeted: true}
    events = [{:tweet_retweeted, %{tweet_id: tweet.id}}]
    {:ok, newTweet, events}
  end
end
