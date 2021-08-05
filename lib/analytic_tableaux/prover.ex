defmodule AnalyticTableaux.Prover do
  defstruct(
    status: :unknown,
    history: [],
    counterexample: []
  )
  alias AnalyticTableaux.Node

  def prove(sequent = [_h|_t]) do
    starting_point = [Node.from_sequent(sequent)]
    prove(starting_point, false, nil, [starting_point])
  end

  defp prove([], _found_counterexample? = false, nil, history) do
    %__MODULE__{status: :valid, history: Enum.reverse(history)}
  end

  defp prove(_queue, _found_counterexample? = true, counterexample, history) do
    %__MODULE__{status: :not_valid, history: Enum.reverse(history), counterexample: counterexample}
  end

  defp prove(queue, _found_counterexample? = false, nil, history) do
    {next_queue, found_counterexample?, counterexample} = step(queue)
    prove(next_queue, found_counterexample?, counterexample, [next_queue|history])
  end

  def step([node|remaining]) do
    cond do
      Node.closed?(node) ->
        {remaining, _found_counterexample? = false, nil}
      Node.complete?(node) ->
        {remaining, _found_counterexample? = true, node}
      true ->
        {Node.next(node) ++ remaining, _found_counterexample? = false, nil}
    end
  end

  def get_status(%__MODULE__{status: status}) do
    status
  end
end
