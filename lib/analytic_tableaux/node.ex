defmodule AnalyticTableaux.Node do

  alias AnalyticTableaux.SignedFormula
  alias AnalyticTableaux.Rules

  def from_sequent(sequent = [_h|_t]) do
    sequent
  end

  def complete?(node) do
    node
    |> Enum.all?(&SignedFormula.atomic?/1)
  end

  def closed?(node) do
    node
    |> Enum.any?(contradiction?(node))
  end

  def contradiction?(node) do
    fn formula ->
      Enum.member?(node, SignedFormula.contradict(formula))
    end
  end

  defp nonbranching_first(formulas) do
    formulas
    |> Enum.sort_by(&SignedFormula.branching?/1)
  end

  def next(node) do
    next_complex_formula = Enum.find(node, fn f -> not SignedFormula.atomic?(f) end)

    Rules.apply(next_complex_formula)
    |> next(node, next_complex_formula)
    |> Enum.map(&nonbranching_first/1)
  end

  # Non-branching produces single formula (i.e. NOT rule)
  defp next({_left = {formula1}, _right = {}}, node, remove) do
    [
      [
        formula1
        | Enum.filter(node, fn f -> f != remove end)
      ]
    ]
  end

  # Non-branching
  defp next({_left = {formula1, formula2}, _right = {}}, node, remove) do
    [
      [
        formula1, formula2
        | Enum.reject(node, fn f -> f == remove end)
      ]
    ]
  end

  # Branching
  defp next({_left = {formula1}, _right = {formula2}}, node, remove) do
    decomposed_formula_removed = Enum.reject(node, fn f -> f == remove end)
    [
      [formula1 | decomposed_formula_removed],
      [formula2 | decomposed_formula_removed]
    ]
  end

  # Branching, two formulas each branch (i.e. IFF rule)
  defp next({_left = {formula1, formula2}, _right = {formula3, formula4}}, node, remove) do
    decomposed_formula_removed = Enum.reject(node, fn f -> f == remove end)
    [
      [formula1, formula2 | decomposed_formula_removed],
      [formula3, formula4 | decomposed_formula_removed]
    ]
  end

end
