defmodule AnalyticTableaux.SignedFormula do
  defstruct formula: :nil, truth_value: true

  alias AnalyticTableaux.Formula

  def atomic?(%__MODULE__{formula: formula}) do
    Formula.atomic?(formula)
  end

  def contradict(%__MODULE__{formula: formula, truth_value: truth_value}) do
    %__MODULE__{formula: formula, truth_value: not truth_value}
  end

  def branching?(%__MODULE__{formula: {:or, _a, _b}, truth_value: true}) do
    true
  end

  def branching?(%__MODULE__{formula: {:and, _a, _b}, truth_value: false}) do
    true
  end

  def branching?(%__MODULE__{formula: {:implies, _a, _b}, truth_value: true}) do
    true
  end

  def branching?(%__MODULE__{formula: {:iff, _a, _b}}) do
    true
  end

  def branching?(%__MODULE__{}) do
    false
  end

end

alias AnalyticTableaux.SignedFormula

defimpl String.Chars, for: SignedFormula do
  alias AnalyticTableaux.Formula

  def to_string(%SignedFormula{formula: formula, truth_value: truth_value}) do
    truth = if truth_value, do: "T", else: "F"
    "#{truth} #{Formula.pretty_print(formula)}"
  end
end
