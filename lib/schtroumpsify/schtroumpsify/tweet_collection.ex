defmodule Schtroumpsify.TweetCollection do
   defstruct tweets: %{}, tweetIds: []

   alias Schtroumpsify.TweetCollection
   alias Schtroumpsify.Tweet

   def new(), do: %TweetCollection{}

   def addTweet(tweetCollection, creationFn) do
     {:ok, tweet, events} = creationFn.()
     newCollection = %TweetCollection{tweetCollection | tweets: Map.put(tweetCollection.tweets, tweet.id, tweet), tweetIds: tweetCollection.tweetIds ++ [tweet.id]}
     {:ok, newCollection, events}
   end

   def listAll(tweetCollection) do
      tweetCollection.tweets
   end

   def updateTweet(tweetCollection, tweetId, updateFn) do
      case Map.fetch(tweetCollection.tweets, tweetId) do
        :error ->
          {:ok, tweetCollection, []}

        {:ok, oldTweet} ->
          {:ok, newTweet, events} = updateFn.(oldTweet)
          newTweets = Map.put(tweetCollection.tweets, tweetId, newTweet)
          {:ok, %TweetCollection{tweetCollection | tweets: newTweets}, events}
      end
   end

   def take(tweetCollection, amount) do
     Enum.take(tweetCollection.tweetIds, -amount)
     |> Enum.map(&Map.fetch!(tweetCollection.tweets, &1))
     |> Enum.reverse
   end
end
