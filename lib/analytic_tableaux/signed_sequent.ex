defmodule AnalyticTableaux.SignedSequent do

  alias AnalyticTableaux.SignedFormula
  alias AnalyticTableaux.Formula

  @type unsigned_sequent :: nonempty_list(Formula.t())
  @type t() :: nonempty_list(SignedFormula.t())

  @spec from_unsigned(unsigned_sequent) :: __MODULE__.t()
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
