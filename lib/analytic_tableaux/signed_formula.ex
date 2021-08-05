defmodule AnalyticTableaux.SignedFormula do
  defstruct formula: :nil, truth_value: true

  alias AnalyticTableaux.Formula

  def atomic?(%__MODULE__{formula: formula}) do
    Formula.atomic?(formula)
  end

  def contradict(%__MODULE__{formula: formula, truth_value: truth_value}) do
    %__MODULE__{formula: formula, truth_value: not truth_value}
  end
end
