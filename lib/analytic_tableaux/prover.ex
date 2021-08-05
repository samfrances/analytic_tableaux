defmodule AnalyticTableaux.Prover do
  defstruct(
    status: :unknown,
    history: [],
    counterexample: []
  )
  alias AnalyticTableaux.Node

  def prove(sequent = [_h|_t]) do
    starting_point = [Node.from_sequent(sequent)]
    prove(starting_point, _counterexample = nil, [starting_point])
  end

  defp prove([], _counterexample = nil, history) do
    %__MODULE__{status: :valid, history: Enum.reverse(history)}
  end

  defp prove(queue, _counterexample? = nil, history) do
    {next_queue, counterexample} = step(queue)
    prove(next_queue, counterexample, [next_queue|history])
  end

  defp prove(_queue, counterexample, history) do
    %__MODULE__{
      status: :not_valid,
      history: Enum.reverse(history),
      counterexample: counterexample
    }
  end

  def step([node|remaining]) do
    cond do
      Node.closed?(node) ->
        {remaining, _counterexample? = nil}
      Node.complete?(node) ->
        {remaining, _counterexample? = node}
      true ->
        {Node.next(node) ++ remaining, _counterexample? = nil}
    end
  end

  def get_status(%__MODULE__{status: status}) do
    status
  end
end
