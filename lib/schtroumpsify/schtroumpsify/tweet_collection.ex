defmodule Schtroumpsify.TweetCollection do
   defstruct listOfTweets: []

   alias Schtroumpsify.TweetCollection

   def new(), do: %TweetCollection{}

   def addTweet(tweetCollection, tweet) do
      %TweetCollection{tweetCollection | listOfTweets: [tweet] ++ tweetCollection.listOfTweets}
   end

   def listAll(tweetCollection) do
      IO.inspect(tweetCollection)
      tweetCollection.listOfTweets
   end

end
