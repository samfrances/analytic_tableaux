defmodule AnalyticTableaux do
  @moduledoc """
  Documentation for `AnalyticTableaux`.
  """
  alias AnalyticTableaux.Parser
  alias AnalyticTableaux.SignedSequent
  alias AnalyticTableaux.BlockProver

  def prove(sequent_text, prover \\ BlockProver) do
    sequent_text
    |> Parser.parse()
    |> SignedSequent.from_unsigned()
    |> prover.prove()
  end

  defdelegate get_status(result), to: BlockProver

  defdelegate get_countervaluation(result), to: BlockProver
end
