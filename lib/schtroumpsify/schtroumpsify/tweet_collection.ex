require Logger
defmodule Schtroumpsify.TweetCollection do
   defstruct tweets: %{}, tweetIds: []

   alias Schtroumpsify.TweetCollection

   def new(), do: %TweetCollection{}

   def listAll(tweetCollection) do
      tweetCollection.tweets
   end

   def updateTweet(tweetCollection, tweet) do
     case Map.fetch(tweetCollection.tweets, tweet.id) do
       :error ->
         newTweets = %TweetCollection{tweetCollection | tweets: Map.put(tweetCollection.tweets, tweet.id, tweet), tweetIds: tweetCollection.tweetIds ++ [tweet.id]}
         {:ok, newTweets}

       {:ok, _} ->
         newTweets = Map.put(tweetCollection.tweets, tweet.id, tweet)
         {:ok, %TweetCollection{tweetCollection | tweets: newTweets}}
     end
   end

   def take(tweetCollection, amount) do
     Enum.take(tweetCollection.tweetIds, -amount)
     |> Enum.map(&Map.fetch!(tweetCollection.tweets, &1))
     |> Enum.reverse
   end
end
