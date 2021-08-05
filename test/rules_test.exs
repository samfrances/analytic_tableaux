defmodule RulesTest do
  use ExUnit.Case

  alias AnalyticTableaux.Rules
  alias AnalyticTableaux.SignedFormula

  test "T NOT rule on atomic formulas" do
    input = %SignedFormula{ formula: {:not, :p}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: :p, truth_value: false}
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "F NOT rule on atomic formulas" do
    input = %SignedFormula{ formula: {:not, :p}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: :p, truth_value: true}
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "T NOT rule nested" do
    input = %SignedFormula{ formula: {:not, {:not, :p}}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: {:not, :p}, truth_value: false}
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "F NOT rule nested atomic formulas" do
    input = %SignedFormula{ formula: {:not, {:not, :p}}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: {:not, :p}, truth_value: true}
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "T NOT rule on complex formulas" do
    complex_formula = {:or, {:not, :d}, {:implies, :c, {:and, :a, :z}}}
    input = %SignedFormula{ formula: {:not, complex_formula}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: complex_formula, truth_value: false}
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "F NOT rule on complex formulas" do
    complex_formula = {:or, {:not, :d}, {:implies, :c, {:and, :a, :z}}}
    input = %SignedFormula{ formula: {:not, complex_formula}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: complex_formula, truth_value: true}
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

  test "T OR rule on atomic formulas" do
    input = %SignedFormula{ formula: {:or, :a, :b}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: :a, truth_value: true},
      },
      {
        %SignedFormula{ formula: :b, truth_value: true},
      }
    }
    assert Rules.apply(input) == output
  end

  test "F OR rule on atomic formulas" do
    input = %SignedFormula{ formula: {:or, :a, :b}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: :a, truth_value: false},
        %SignedFormula{ formula: :b, truth_value: false},
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "T OR rule on complex formulas" do
    disjunct_a = {:not, :a}
    disjunct_b = :b
    input = %SignedFormula{ formula: {:or, disjunct_a, disjunct_b}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: disjunct_a, truth_value: true},
      },
      {
        %SignedFormula{ formula: disjunct_b, truth_value: true},
      }
    }
    assert Rules.apply(input) == output
  end

  test "F OR rule on complex formulas" do
    disjunct_a = {:not, :a}
    disjunct_b = :b
    input = %SignedFormula{ formula: {:or, disjunct_a, disjunct_b}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: disjunct_a, truth_value: false},
        %SignedFormula{ formula: disjunct_b, truth_value: false},
      },
      {}
    }
    assert Rules.apply(input) == output
  end

  test "T IMPLIES rule on atomic formula" do
    formula_a = :a
    formula_b = :b
    input = %SignedFormula{ formula: {:implies, formula_a, formula_b}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: formula_a, truth_value: false},
      },
      {
        %SignedFormula{ formula: formula_b, truth_value: true},
      }
    }

    assert Rules.apply(input) == output
  end

  test "F IMPLIES rule on atomic formula" do
    formula_a = :a
    formula_b = :b
    input = %SignedFormula{ formula: {:implies, formula_a, formula_b}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: formula_a, truth_value: true},
        %SignedFormula{ formula: formula_b, truth_value: false},
      },
      {}
    }

    assert Rules.apply(input) == output
  end

  test "T IMPLIES rule on complex formula" do
    formula_a = {:or, {:not, :d}, {:implies, :c, {:and, :a, :z}}}
    formula_b = {:and, :b, {:not, :b}}
    input = %SignedFormula{ formula: {:implies, formula_a, formula_b}, truth_value: true}
    output = {
      {
        %SignedFormula{ formula: formula_a, truth_value: false},
      },
      {
        %SignedFormula{ formula: formula_b, truth_value: true},
      }
    }

    assert Rules.apply(input) == output
  end

  test "F IMPLIES rule on complex formula" do
    formula_a = {:or, {:not, :d}, {:implies, :c, {:and, :a, :z}}}
    formula_b = {:and, :b, {:not, :b}}
    input = %SignedFormula{ formula: {:implies, formula_a, formula_b}, truth_value: false}
    output = {
      {
        %SignedFormula{ formula: formula_a, truth_value: true},
        %SignedFormula{ formula: formula_b, truth_value: false},
      },
      {}
    }

    assert Rules.apply(input) == output
  end

end
