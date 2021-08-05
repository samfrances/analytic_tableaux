defmodule SignedSequentTest do
  use ExUnit.Case

  alias AnalyticTableaux.SignedSequent
  alias AnalyticTableaux.SignedFormula

  test "should assign false to conclusion and true to premises" do
    seq = [:a, :b, :c]
    expected = [
      %SignedFormula{formula: :a, truth_value: true},
      %SignedFormula{formula: :b, truth_value: true},
      %SignedFormula{formula: :b, truth_value: false},
    ]
    assert SignedSequent.from_unsigned(seq)
  end

  test "example with more complex formulas" do
    form_one = {:and, :a, :b}
    form_two = {:not, {:or, :a, :b}}
    form_three = :a
    form_four = {:and, {:or, :p, {:not, :q}}, :c}
    seq = [form_one, form_two, form_three, form_four]
    expected = [
      %SignedFormula{formula: form_one, truth_value: true},
      %SignedFormula{formula: form_two, truth_value: true},
      %SignedFormula{formula: form_three, truth_value: true},
      %SignedFormula{formula: form_four, truth_value: false},
    ]
    assert SignedSequent.from_unsigned(seq)
  end

end
