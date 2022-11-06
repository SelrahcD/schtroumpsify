defmodule Schtroumpsify.TweetTransformerTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Schtroumpsify.TweetTransformer
  alias Schtroumpsify.Tweet

  @tweetId 17

  test "transforms a tweet to its schtroumpf equivalent" do

    {:ok, originalTweet, _} = Tweet.from(%{id: @tweetId, text: "Il mange une pomme."})

    parsing = il_mange_une_pomme_parse_result()

    %{tweet: tweet, events: events} = TweetTransformer.transform(%{tweet: originalTweet, parsing: parsing})

    result = %{tweet: tweet, events: events}

    expectedTweet1 = originalTweet
                    |> Map.put(:schtroumpsified_text, "Il mange une schtroumpf.")
                    |> Map.put(:is_schtroumpsified, true)

    expectedTweet2 = originalTweet
                     |> Map.put(:schtroumpsified_text, "Il schtroumpfe une pomme.")
                     |> Map.put(:is_schtroumpsified, true)

    expectedEvents1 =[{:tweet_schtroumpsified, %{tweet_id: @tweetId, schtroumpsified_text: "Il mange une schtroumpf." }}]
    expectedEvents2 =[{:tweet_schtroumpsified, %{tweet_id: @tweetId, schtroumpsified_text: "Il schtroumpfe une pomme." }}]

    expectedResult1 = %{tweet: expectedTweet1, events: expectedEvents1}
    expectedResult2 = %{tweet: expectedTweet2, events: expectedEvents2}

    assert result == expectedResult1 or result == expectedResult2
  end


  describe "text transformation" do
    test "replaces word with schtroumpf word" do

      {:ok, tweet, _} = Tweet.from(%{text: "Il mange un oiseau"})
      transformation = {:ok, %{"form" => "oiseau"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Il mange un schtroumpf"
    end

    test "replaces previous \"s’\" with \"se\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "Il s’égare"})
      transformation = {:ok, %{"form" => "égare"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Il se schtroumpf"
    end

    test "replaces previous \"S’\" with \"Se\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "S’égare"})
      transformation = {:ok, %{"form" => "égare"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Se schtroumpf"
    end

    test "replaces previous \"j’\" with \"je\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "j’éclaire"})
      transformation = {:ok, %{"form" => "éclaire"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "je schtroumpf"
    end

    test "replaces previous \"J’\" with \"Je\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "J’éclaire"})
      transformation = {:ok, %{"form" => "éclaire"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Je schtroumpf"
    end

    test "replaces previous \"n’\" with \"ne\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "il n’est pas"})
      transformation = {:ok, %{"form" => "est"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "il ne schtroumpf pas"
    end

    test "replaces previous \"N’\" with \"Ne\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "N’est pas"})
      transformation = {:ok, %{"form" => "est"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Ne schtroumpf pas"
    end

    test "replaces previous \"d’\" with \"de\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "d’idée"})
      transformation = {:ok, %{"form" => "idée"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "de schtroumpf"
    end

    test "replaces previous \"D’\" with \"De\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "D’idée"})
      transformation = {:ok, %{"form" => "idée"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "De schtroumpf"
    end

    test "replaces previous \"c’\" with \"ce\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "c’était"})
      transformation = {:ok, %{"form" => "était"}, "schtroumpfait"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "ce schtroumpfait"
    end

    test "replaces previous \"C’\" with \"ce\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "C’était"})
      transformation = {:ok, %{"form" => "était"}, "schtroumpfait"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Ce schtroumpfait"
    end

    test "replaces previous \"de l’\" with \"du\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "de l’eau"})
      transformation = {:ok, %{"form" => "eau"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "du schtroumpf"
    end

    test "replaces previous \"De l’\" with \"Du\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "De l’eau"})
      transformation = {:ok, %{"form" => "eau"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Du schtroumpf"
    end

    test "replaces previous \"à les\" with \"aux\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "à les trucs"})
      transformation = {:ok, %{"form" => "trucs"}, "schtroumpfs"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "aux schtroumpfs"
    end

    test "replaces previous \"À les\" with \"Aux\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "À les trucs"})
      transformation = {:ok, %{"form" => "trucs"}, "schtroumpfs"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Aux schtroumpfs"
    end

    test "replaces previous \"à le\" with \"au\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "Touches pas à le truc"})
      transformation = {:ok, %{"form" => "truc"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Touches pas au schtroumpf"
    end

    test "replaces previous \"À le\" with \"Au\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "Touches pas À le truc"})
      transformation = {:ok, %{"form" => "truc"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Touches pas Au schtroumpf"
    end

    test "replaces previous \"à la\" with \"au\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "Touches pas à la chose"})
      transformation = {:ok, %{"form" => "chose"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Touches pas au schtroumpf"
    end

    test "replaces previous \"À la\" with \"Au\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "Touches pas À la chose"})
      transformation = {:ok, %{"form" => "chose"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Touches pas Au schtroumpf"
    end

    test "replaces previous \"l’\" with \"le\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "l’eau"})
      transformation = {:ok, %{"form" => "eau"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "le schtroumpf"
    end

    test "replaces previous \"L’\" with \"Le\"" do

      {:ok, tweet, _} = Tweet.from(%{text: "L’eau"})
      transformation = {:ok, %{"form" => "eau"}, "schtroumpf"}

      new_text = TweetTransformer.transform_text(transformation, tweet)

      assert new_text == "Le schtroumpf"
    end

    test "keeps the same case" do

      {:ok, tweet_lower_case, _} = Tweet.from(%{text: "minuscule"})
      transformation_lower_case = {:ok, %{"form" => "minuscule"}, "schtroumpf"}

      {:ok, tweet_capitalized, _} = Tweet.from(%{text: "Majuscule"})
      transformation_capitalized = {:ok, %{"form" => "Majuscule"}, "schtroumpf"}

      {:ok, tweet_upper_case, _} = Tweet.from(%{text: "MAJUSCULE"})
      transformation_upper_case = {:ok, %{"form" => "MAJUSCULE"}, "schtroumpf"}

      new_text_lower_case = TweetTransformer.transform_text(transformation_lower_case, tweet_lower_case)
      new_text_capitalize = TweetTransformer.transform_text(transformation_capitalized, tweet_capitalized)
      new_text_upper_case = TweetTransformer.transform_text(transformation_upper_case, tweet_upper_case)

      assert new_text_lower_case == "schtroumpf"
      assert new_text_capitalize == "Schtroumpf"
      assert new_text_upper_case == "SCHTROUMPF"
    end
  end

  token_transformations = [
    {"nom commun", %{"cpos" => "NC"}, "schtroumpf"},
    {"nom commun singuler", %{"cpos" => "NC", "mstag" => %{"n" => "s"}}, "schtroumpf"},
    {"nom commun pluriel", %{"cpos" => "NC", "mstag" => %{"n" => "p"}}, "schtroumpfs"},
    {"adjectif", %{"cpos" => "ADJ"}, "schtroumpf"},
    {"adjectif singuler", %{"cpos" => "ADJ", "mstag" => %{"n" => "s"}}, "schtroumpf"},
    {"adjectif pluriel", %{"cpos" => "ADJ", "mstag" => %{"n" => "p"}}, "schtroumpfs"},
    {"verbe au participe passé masculin singulier", %{"cpos" => "VPP", "mstag" => %{"g" => "m", "n" => "s"}}, "schtroumpfé"},
    {"verbe au participe passé feminin singulier", %{"cpos" => "VPP", "mstag" => %{"g" => "f", "n" => "s"}}, "schtroumpfée"},
    {"verbe au participe passé masculin pluriel", %{"cpos" => "VPP", "mstag" => %{"g" => "m", "n" => "p"}}, "schtroumpfés"},
    {"verbe au participe passé feminin pluriel", %{"cpos" => "VPP", "mstag" => %{"g" => "f", "n" => "p"}}, "schtroumpfées"},
    {"verbe à l'infinif", %{"cpos" => "VINF"}, "schtroumpfer"},
    {"adverbe terminant par ement", %{"cpos" => "ADV", "form" => "tellement"}, "schtroumpfement"},

    {"verbe à l'indicatif présent, 1ere personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "s", "p" => "1"}}, "schtroumpfe"},
    {"verbe à l'indicatif présent, 2eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "s", "p" => "2"}}, "schtroumpfes"},
    {"verbe à l'indicatif présent, 3eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "s", "p" => "3"}}, "schtroumpfe"},
    {"verbe à l'indicatif présent, 1ere personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "p", "p" => "1"}}, "schtroumpfons"},
    {"verbe à l'indicatif présent, 2eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "p", "p" => "2"}}, "schtroumpfez"},
    {"verbe à l'indicatif présent, 3eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "p", "p" => "3"}}, "schtroumpfent"},

    {"verbe à l'indicatif imparfait, 1ere personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "s", "p" => "1"}}, "schtroumpfais"},
    {"verbe à l'indicatif imparfait, 2eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "s", "p" => "2"}}, "schtroumpfais"},
    {"verbe à l'indicatif imparfait, 3eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "s", "p" => "3"}}, "schtroumpfait"},
    {"verbe à l'indicatif imparfait, 1ere personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "p", "p" => "1"}}, "schtroumpfions"},
    {"verbe à l'indicatif imparfait, 2eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "p", "p" => "2"}}, "schtroumpfiez"},
    {"verbe à l'indicatif imparfait, 3eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "p", "p" => "3"}}, "schtroumpfaient"},

    {"verbe à l'indicatif futur, 1ere personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "s", "p" => "1"}}, "schtroumpferai"},
    {"verbe à l'indicatif futur, 2eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "s", "p" => "2"}}, "schtroumpferas"},
    {"verbe à l'indicatif futur, 3eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "s", "p" => "3"}}, "schtroumpfera"},
    {"verbe à l'indicatif futur, 1ere personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "p", "p" => "1"}}, "schtroumpferons"},
    {"verbe à l'indicatif futur, 2eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "p", "p" => "2"}}, "schtroumpferez"},
    {"verbe à l'indicatif futur, 3eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "p", "p" => "3"}}, "schtroumpferont"},

    {"verbe à l'indicatif passé, 1ere personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "s", "p" => "1"}}, "schtroumpfai"},
    {"verbe à l'indicatif passé, 2eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "s", "p" => "2"}}, "schtroumpfas"},
    {"verbe à l'indicatif passé, 3eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "s", "p" => "3"}}, "schtroumpfa"},
    {"verbe à l'indicatif passé, 1ere personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "p", "p" => "1"}}, "schtroumpfâmes"},
    {"verbe à l'indicatif passé, 2eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "p", "p" => "2"}}, "schtroumpfâtes"},
    {"verbe à l'indicatif passé, 3eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "p", "p" => "3"}}, "schtroumpfèrent"},

    {"verbe au conditionnel, 1ere personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "s", "p" => "1"}}, "schtroumpferais"},
    {"verbe au conditionnel, 2eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "s", "p" => "2"}}, "schtroumpferais"},
    {"verbe au conditionnel, 3eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "s", "p" => "3"}}, "schtroumpferait"},
    {"verbe au conditionnel, 1ere personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "p", "p" => "1"}}, "schtroumpferions"},
    {"verbe au conditionnel, 2eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "p", "p" => "2"}}, "schtroumpferiez"},
    {"verbe au conditionnel, 3eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "p", "p" => "3"}}, "schtroumpferaient"},

    {"verbe à l'imperatif, 2eme personne du singulier", %{"cpos" => "V", "mstag" => %{"m" => "imp", "n" => "s", "p" => "2"}}, "schtroumpfe"},
    {"verbe à l'imperatif', 1ere personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "imp", "n" => "p", "p" => "1"}}, "schtroumpfons"},
    {"verbe à l'imperatif', 2eme personne du pluriel", %{"cpos" => "V", "mstag" => %{"m" => "imp", "n" => "p", "p" => "2"}}, "schtroumpfez"},
  ]

  for {name, token, expected_schtroumpf_equivalent} <- token_transformations do
    @token token
    @expected_schtroumpf_equivalent expected_schtroumpf_equivalent
    @name name

    test "transforms a " <> @name <> " token to its schtroumpf equivalent \"" <> @expected_schtroumpf_equivalent <> "\""do
      assert TweetTransformer.transform_token!(build_token(@token)) === {:ok, @expected_schtroumpf_equivalent}
    end

  end

  test "doesnt transforms an adverb token not ending with ement"do
    assert TweetTransformer.transform_token!(%{"cpos" => "ADV", "form" => "pas"}) === {:error, :do_not_convert_adverbe_not_ending_with_ement}
  end

  test "doesnt transforms a number" do
    assert TweetTransformer.transform_token!(%{"form" => "2022"}) === {:error, :do_not_transform_number}
  end


  test "doesnt replace auxiliaires de temps" do
    {:ok, originalTweet, _} = Tweet.from(%{id: @tweetId, text: "Il a mangé."})

    parsing = %{
      "1" => %{
        "cpos" => "CLS",
        "deprel" => "suj",
        "form" => "Il",
        "head" => "2",
        "id" => "1",
        "lemma" => "il",
        "mstag" => %{"g" => "m", "n" => "s", "p" => "3", "s" => "suj"},
        "pos" => "CL"
      },
      "2" => %{
        "cpos" => "V",
        "deprel" => "aux_tps",
        "form" => "a",
        "head" => "0",
        "id" => "2",
        "lemma" => "avoir",
        "mstag" => %{
           "m" => "ind",
           "n" => "s",
           "p" => "3",
           "t"=>"pst"
          },
        "pos" => "V"
      },
      "3" => %{
       "cpos" => "VPP",
       "deprel" => "root",
       "form" => "mangé",
       "head" => "0",
       "id" => "2",
       "lemma" => "manger",
       "mstag" => %{
        "g" => "m",
        "n"=>"s"
         }
       },
      "4" => %{
        "cpos" => "PONCT",
        "deprel" => "ponct",
        "form" => ".",
        "head" => "2",
        "id" => "5",
        "lemma" => ".",
        "mstag" => %{},
        "pos" => "PONCT"
      }
    }

    %{tweet: tweet, events: events} = TweetTransformer.transform(%{tweet: originalTweet, parsing: parsing})

    result = %{tweet: tweet, events: events}

    expectedTweet = originalTweet
                     |> Map.put(:schtroumpsified_text, "Il a schtroumpfé.")
                     |> Map.put(:is_schtroumpsified, true)


    expectedEvents =[{:tweet_schtroumpsified, %{tweet_id: @tweetId, schtroumpsified_text: "Il a schtroumpfé." }}]

    expectedResult = %{tweet: expectedTweet, events: expectedEvents}

    assert result == expectedResult

  end

  test "doesnt replace auxiliaires de temps passé" do
    {:ok, originalTweet, _} = Tweet.from(%{id: @tweetId, text: "Il est mangé."})

    parsing = %{
      "1" => %{
        "cpos" => "CLS",
        "deprel" => "suj",
        "form" => "Il",
        "head" => "2",
        "id" => "1",
        "lemma" => "il",
        "mstag" => %{"g" => "m", "n" => "s", "p" => "3", "s" => "suj"},
        "pos" => "CL"
      },
      "2" => %{
        "cpos" => "V",
        "deprel" => "aux_pass",
        "form" => "est",
        "head" => "0",
        "id" => "2",
        "lemma" => "être",
        "mstag" => %{
          "m" => "ind",
          "n" => "s",
          "p" => "3",
          "t"=>"pst"
        },
        "pos" => "V"
      },
      "3" => %{
        "cpos" => "VPP",
        "deprel" => "root",
        "form" => "mangé",
        "head" => "0",
        "id" => "2",
        "lemma" => "manger",
        "mstag" => %{
          "g" => "m",
          "n"=>"s"
        }
      },
      "4" => %{
        "cpos" => "PONCT",
        "deprel" => "ponct",
        "form" => ".",
        "head" => "2",
        "id" => "5",
        "lemma" => ".",
        "mstag" => %{},
        "pos" => "PONCT"
      }
    }

    %{tweet: tweet, events: events} = TweetTransformer.transform(%{tweet: originalTweet, parsing: parsing})

    result = %{tweet: tweet, events: events}

    expectedTweet = originalTweet
                    |> Map.put(:schtroumpsified_text, "Il est schtroumpfé.")
                    |> Map.put(:is_schtroumpsified, true)


    expectedEvents =[{:tweet_schtroumpsified, %{tweet_id: @tweetId, schtroumpsified_text: "Il est schtroumpfé." }}]

    expectedResult = %{tweet: expectedTweet, events: expectedEvents}

    assert result == expectedResult

  end

  defp il_mange_une_pomme_parse_result do
    %{
      "1" => %{
        "cpos" => "CLS",
        "deprel" => "suj",
        "form" => "Il",
        "head" => "2",
        "id" => "1",
        "lemma" => "il",
        "mstag" => %{"g" => "m", "n" => "s", "p" => "3", "s" => "suj"},
        "pos" => "CL"
      },
      "2" => %{
        "cpos" => "V",
        "deprel" => "root",
        "form" => "mange",
        "head" => "0",
        "id" => "2",
        "lemma" => "manger",
        "mstag" => %{
          "g" => "m",
          "m" => "ind",
          "n" => "s",
          "p" => "3",
          "t" => "pst"
        },
        "pos" => "V"
      },
      "3" => %{
        "cpos" => "DET",
        "deprel" => "det",
        "form" => "une",
        "head" => "4",
        "id" => "3",
        "lemma" => "un",
        "mstag" => %{"g" => "f", "n" => "s"},
        "pos" => "D"
      },
      "4" => %{
        "cpos" => "NC",
        "deprel" => "obj",
        "form" => "pomme",
        "head" => "2",
        "id" => "4",
        "lemma" => "pomme",
        "mstag" => %{"g" => "f", "n" => "s", "s" => "c"},
        "pos" => "N"
      },
      "5" => %{
        "cpos" => "PONCT",
        "deprel" => "ponct",
        "form" => ".",
        "head" => "2",
        "id" => "5",
        "lemma" => ".",
        "mstag" => [],
        "pos" => "PONCT"
      }
    }
  end

  defp build_token(token) do
    %{"form" => ""}
    |> Map.merge(token)
  end

end
