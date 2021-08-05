defmodule RulesTest do
  use ExUnit.Case

  alias AnalyticTableaux.Rules
  alias AnalyticTableaux.SignedFormula

  test "T AND rule on atomic formulas" do
    input = %SignedFormula{ formula: {:and, :a, :b}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: :a, truth_value: true},
        %SignedFormula{ formula: :b, truth_value: true},
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "T AND rule on complex formulas" do
    conjunct_a = {:implies, :a, :b}
    conjunct_b = {:not, :a}
    input = %SignedFormula{ formula: {:and, conjunct_a, conjunct_b}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: conjunct_a, truth_value: true},
        %SignedFormula{ formula: conjunct_b, truth_value: true},
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "F AND rule on atomic formulas" do
    input = %SignedFormula{ formula: {:and, :a, :b}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: :a, truth_value: false},
      },
      {
        %SignedFormula{ formula: :b, truth_value: false},
      }
    }
    assert Rules.apply(input) == output
  end

  test "F AND rule on complex formulas" do
    conjunct_a = {:implies, :a, :b}
    conjunct_b = {:not, :a}
    input = %SignedFormula{ formula: {:and, conjunct_a, conjunct_b}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: conjunct_a, truth_value: false},
      },
      {
        %SignedFormula{ formula: conjunct_b, truth_value: false},
      }
    }
    assert Rules.apply(input) == output
  end

end
