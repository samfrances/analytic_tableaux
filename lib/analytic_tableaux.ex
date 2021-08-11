defmodule AnalyticTableaux do
  @moduledoc """
  Documentation for `AnalyticTableaux`.
  """
  alias AnalyticTableaux.Parser
  alias AnalyticTableaux.SignedSequent
  alias AnalyticTableaux.Prover

  def prove(sequent_text) do
    sequent_text
    |> Parser.parse()
    |> SignedSequent.from_unsigned()
    |> Prover.prove()
  end

  defdelegate get_status(result), to: Prover

  defdelegate get_countervaluation(result), to: Prover
end
