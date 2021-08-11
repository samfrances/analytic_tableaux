defmodule AnalyticTableaux.Prover do
  defstruct(
    status: :unknown,
    history: [],
    countervaluation: []
  )
  alias AnalyticTableaux.Node
  alias AnalyticTableaux.SignedFormula

  def prove(sequent = [_h|_t]) do
    starting_point = [Node.from_sequent(sequent)]
    prove(starting_point, _countervaluation = nil, [starting_point])
  end

  def get_status(%__MODULE__{status: status}) do
    status
  end

  def get_countervaluation(%__MODULE__{countervaluation: counterv}) do
    simplify_countervaluation(counterv)
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
