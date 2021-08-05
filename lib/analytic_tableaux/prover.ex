defmodule AnalyticTableaux.Prover do
  defstruct(
    status: :unknown,
    history: []
  )
  alias AnalyticTableaux.Node

  def prove(sequent = [_h|_t]) do
    starting_point = [Node.from_sequent(sequent)]
    prove(starting_point, false, [starting_point])
  end

  defp prove([], _found_counterexample? = false, history) do
    %__MODULE__{status: :valid, history: Enum.reverse(history)}
  end

  defp prove(_queue, _found_counterexample? = true, history) do
    %__MODULE__{status: :not_valid, history: Enum.reverse(history)}
  end

  defp prove(queue, _found_counterexample? = false, history) do
    {next_queue, found_counterexample?} = step(queue)
    prove(next_queue, found_counterexample?, [next_queue|history])
  end

  def step([node|remaining]) do
    cond do
      Node.closed?(node) ->
        {remaining, _found_counterexample? = false}
      Node.complete?(node) ->
        {remaining, _found_counterexample? = true}
      true ->
        {Node.next(node) ++ remaining, _found_counterexample? = false}
    end
  end

  def get_status(%__MODULE__{status: status}) do
    status
  end
end
