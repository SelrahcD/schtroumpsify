require Logger

defmodule Schtroumpsify.TweetTransformer do
  @moduledoc false

  alias Schtroumpsify.Tweet
  alias Schtroumpsify.FlowRunner

  def transform(%{tweet: tweet, parsing: parsing} = flow) do
    Logger.debug("Transforming #{tweet.id}")

    schtroumpsified_text = parsing
                           |> find_working_token
                           |> transform_text(tweet)

    flow
    |> FlowRunner.add_to_flow(Tweet.addNewText(tweet, schtroumpsified_text))
  end


  def transform_text({:ok, token, transformation}, tweet) do
      replace(tweet.text, token["form"], transformation)
      |> replace("de l’" <> transformation, "du " <> transformation)
      |> replace("à les " <> transformation, "aux " <> transformation)
      |> replace("à le " <> transformation, "au " <> transformation)
      |> replace("à la " <> transformation, "au " <> transformation)
      |> replace("s’" <> transformation, "se " <> transformation)
      |> replace("j’" <> transformation, "je " <> transformation)
      |> replace("n’" <> transformation, "ne " <> transformation)
      |> replace("d’" <> transformation, "de " <> transformation)
      |> replace("c’" <> transformation, "ce " <> transformation)
      |> replace("l’" <> transformation, "le " <> transformation)
  end


  def transform_token!(token) do
    case Float.parse(token["form"]) do
      {_, _} -> {:error, :do_not_transform_number}
      _ -> transform_accepted_token!(token)
    end
  end

  def transform_accepted_token!(token) do
    case token do
      %{"lemma" => "_URL"} -> {:error, :cant_convert_url}
      %{"cpos" => "NC", "mstag" => %{"n" => "p"}} -> {:ok, "schtroumpfs"}
      %{"cpos" => "NC"} -> {:ok, "schtroumpf"}
      %{"cpos" => "ADV", "form" => form} -> if String.ends_with?(form, "ement") do {:ok, "schtroumpfement"} else {:error, :do_not_convert_adverbe_not_ending_with_ement} end
      %{"cpos" => "ADJ", "mstag" => %{"n" => "p"}} -> {:ok, "schtroumpfs"}
      %{"cpos" => "ADJ"} -> {:ok, "schtroumpf"}

      %{"cpos" => "VPP", "mstag" => %{"g" => "f", "n" => "p"}} -> {:ok, "schtroumpfées"}
      %{"cpos" => "VPP", "mstag" => %{"g" => "f", "n" => "s"}} -> {:ok, "schtroumpfée"}
      %{"cpos" => "VPP", "mstag" => %{"g" => "m", "n" => "p"}} -> {:ok, "schtroumpfés"}
      %{"cpos" => "VPP", "mstag" => %{"g" => "m", "n" => "s"}} -> {:ok, "schtroumpfé"}

      %{"cpos" => "V", "deprel" => "aux_tps"} -> {:error, :do_not_convert_aux_temps}
      %{"cpos" => "V", "deprel" => "aux_pass"} -> {:error, :do_not_convert_aux_pass}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "s", "p" => "1"}} -> {:ok, "schtroumpfe"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "s", "p" => "2"}} -> {:ok, "schtroumpfes"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "s", "p" => "3"}} -> {:ok, "schtroumpfe"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "p", "p" => "1"}} -> {:ok, "schtroumpfons"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "p", "p" => "2"}} -> {:ok, "schtroumpfez"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "pst", "n" => "p", "p" => "3"}} -> {:ok, "schtroumpfent"}

      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "s", "p" => "1"}} -> {:ok, "schtroumpfais"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "s", "p" => "2"}} -> {:ok, "schtroumpfais"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "s", "p" => "3"}} -> {:ok, "schtroumpfait"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "p", "p" => "1"}} -> {:ok, "schtroumpfions"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "p", "p" => "2"}} -> {:ok, "schtroumpfiez"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "impft", "n" => "p", "p" => "3"}} -> {:ok, "schtroumpfaient"}

      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "s", "p" => "1"}} -> {:ok, "schtroumpferai"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "s", "p" => "2"}} -> {:ok, "schtroumpferas"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "s", "p" => "3"}} -> {:ok, "schtroumpfera"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "p", "p" => "1"}} -> {:ok, "schtroumpferons"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "p", "p" => "2"}} -> {:ok, "schtroumpferez"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "fut", "n" => "p", "p" => "3"}} -> {:ok, "schtroumpferont"}

      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "s", "p" => "1"}} -> {:ok, "schtroumpfai"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "s", "p" => "2"}} -> {:ok, "schtroumpfas"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "s", "p" => "3"}} -> {:ok, "schtroumpfa"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "p", "p" => "1"}} -> {:ok, "schtroumpfâmes"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "p", "p" => "2"}} -> {:ok, "schtroumpfâtes"}
      %{"cpos" => "V", "mstag" => %{"m" => "ind", "t" => "past", "n" => "p", "p" => "3"}} -> {:ok, "schtroumpfèrent"}

      %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "s", "p" => "1"}} -> {:ok, "schtroumpferais"}
      %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "s", "p" => "2"}} -> {:ok, "schtroumpferais"}
      %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "s", "p" => "3"}} -> {:ok, "schtroumpferait"}
      %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "p", "p" => "1"}} -> {:ok, "schtroumpferions"}
      %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "p", "p" => "2"}} -> {:ok, "schtroumpferiez"}
      %{"cpos" => "V", "mstag" => %{"m" => "cond", "n" => "p", "p" => "3"}} -> {:ok, "schtroumpferaient"}

      %{"cpos" => "V", "mstag" => %{"m" => "imp", "n" => "s", "p" => "2"}} -> {:ok, "schtroumpfe"}
      %{"cpos" => "V", "mstag" => %{"m" => "imp", "n" => "p", "p" => "1"}} -> {:ok, "schtroumpfons"}
      %{"cpos" => "V", "mstag" => %{"m" => "imp", "n" => "p", "p" => "2"}} -> {:ok, "schtroumpfez"}

      %{"cpos" => "VINF"} -> {:ok, "schtroumpfer"}
      _ -> {:error, :matching_no_found}
    end
  end

  defp find_working_token(parsing) do
    {key, token} = Enum.random(parsing)
    case transform_token!(token) do
      {:ok, transformation} -> {:ok, token, transformation}
      {:error, _} ->
        parsing = Map.delete(parsing, key)
        find_working_token(parsing)
    end
  end

  defp replace(subject, pattern, replacement) do
    subject
    |> String.replace(String.upcase(pattern), String.upcase(replacement))
    |> String.replace(String.capitalize(pattern), String.capitalize(replacement))
    |> String.replace(pattern, replacement)
  end

end
