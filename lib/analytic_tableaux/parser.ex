defmodule AnalyticTableaux.Parser do

  @spec parse(binary) :: list
  def parse(str) do
    {:ok, sequent} =
      str
      |> tokenize()
      |> :sequent_parser.parse()
    sequent
  end

  @spec tokenize(binary) :: list
  def tokenize(str) do
    {:ok, tokens, _} = str |> to_charlist() |> :sequent_lexer.string()
    tokens
  end

end
