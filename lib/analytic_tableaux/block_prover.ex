defmodule AnalyticTableaux.BlockProver do
  alias AnalyticTableaux.Node
  alias AnalyticTableaux.SignedSequent
  alias AnalyticTableaux.ProverResult

  defstruct(
    status: :unknown,
    history: [],
    countervaluation: []
  )

  @type t() :: %__MODULE__{
    status: ProverResult.proof_status,
    countervaluation: Node.t(),
    history: list(Node.t())
  }

  @spec prove(SignedSequent.t()) :: __MODULE__.t()
  def prove(sequent) when length(sequent) > 0 do
    starting_point = [Node.from_sequent(sequent)]
    prove(starting_point, _countervaluation = nil, [starting_point])
  end

  defp prove([], _countervaluation = nil, history) do
    %__MODULE__{status: :valid, history: Enum.reverse(history)}
  end

  defp prove(queue, _countervaluation = nil, history) do
    {next_queue, counterexample} = step(queue)
    prove(next_queue, counterexample, [next_queue|history])
  end

  defp prove(_queue, countervaluation, history) do
    %__MODULE__{
      status: :not_valid,
      history: Enum.reverse(history),
      countervaluation: countervaluation
    }
  end

  defp step([node|remaining]) do
    cond do
      Node.closed?(node) ->
        {remaining, _countervaluation = nil}
      Node.complete?(node) ->
        {remaining, _countervaluation = node}
      true ->
        {Node.next(node) ++ remaining, _countervaluation = nil}
    end
  end

end

defimpl AnalyticTableaux.ProverResult, for: AnalyticTableaux.BlockProver do
  alias AnalyticTableaux.SignedFormula
  alias AnalyticTableaux.Node
  alias AnalyticTableaux.ProverResult

  def get_status(%AnalyticTableaux.BlockProver{status: status}) do
    status
  end

  @spec get_countervaluation(AnalyticTableaux.Prover.t()) :: ProverResult.simplified_valuation()
  def get_countervaluation(%AnalyticTableaux.BlockProver{countervaluation: counterv}) do
    simplify_countervaluation(counterv)
  end

  @spec simplify_countervaluation(Node.t()) :: ProverResult.simplified_valuation()
  defp simplify_countervaluation(node) do
    node
    |> Enum.map(&unpack_atomic_signed_formula/1)
    |> Map.new()
  end

  defp unpack_atomic_signed_formula(%SignedFormula{
    formula: formula,
    truth_value: truth
  }) when is_atom(formula) do
    {formula, truth}
  end
end
