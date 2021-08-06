defmodule SigneFormulaTest do
  use ExUnit.Case

  alias AnalyticTableaux.SignedFormula

  test "recognizes branching formulas" do
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:or, :a, :b}, truth_value: true}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:or, {:implies, :a, :b}, {:not, :c}}, truth_value: true}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:and, :a, :b}, truth_value: false}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:and, {:implies, :a, :b}, {:not, :c}}, truth_value: false}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:implies, :a, :b}, truth_value: true}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:implies, {:implies, :a, :b}, {:not, :c}}, truth_value: true}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:iff, :a, :b}, truth_value: true}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:iff, {:implies, :a, :b}, {:not, :c}}, truth_value: true}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:iff, :a, :b}, truth_value: false}
    )
    assert SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:iff, {:implies, :a, :b}, {:not, :c}}, truth_value: false}
    )
  end

  test "recognizes non-branching formulas" do
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:or, :a, :b}, truth_value: false}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:or, {:implies, :a, :b}, {:not, :c}}, truth_value: false}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:and, :a, :b}, truth_value: true}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:and, {:implies, :a, :b}, {:not, :c}}, truth_value: true}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:implies, :a, :b}, truth_value: false}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:implies, {:implies, :a, :b}, {:not, :c}}, truth_value: false}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:not, :b}, truth_value: true}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:not, :b}, truth_value: false}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:not, {:implies, {:implies, :a, :b}, {:not, :c}}}, truth_value: true}
    )
    assert not SignedFormula.branching?(
      %AnalyticTableaux.SignedFormula{formula: {:not, {:implies, {:implies, :a, :b}, {:not, :c}}}, truth_value: false}
    )
  end
end
