defmodule AnalyticTableaux.Prover do
  alias AnalyticTableaux.SignedSequent

  @callback prove(SignedSequent.t()) :: AnalyticTableaux.ProverResult.t()
end
