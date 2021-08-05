defmodule AnalyticTableaux.SignedSequent do

  alias AnalyticTableaux.SignedFormula

  def from_unsigned([wff]) do
    [%SignedFormula{formula: wff, truth_value: false}]
  end

  def from_unsigned([wff|rest]) do
    [
      %SignedFormula{formula: wff, truth_value: true}
      | from_unsigned(rest)
    ]
  end

end
