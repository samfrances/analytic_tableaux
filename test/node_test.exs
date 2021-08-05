defmodule NodeTest do
  use ExUnit.Case

  alias AnalyticTableaux.Node
  alias AnalyticTableaux.SignedFormula

  test "Node.complete?" do
    assert Node.complete?(
      Node.from_sequent([
        %SignedFormula{formula: :a, truth_value: false}
      ])
    )
    assert Node.complete?(
      Node.from_sequent([
        %SignedFormula{formula: :a, truth_value: true}
      ])
    )
    assert Node.complete?(
      Node.from_sequent([
        %SignedFormula{formula: :a, truth_value: true},
        %SignedFormula{formula: :b, truth_value: true}
      ])
    )
    assert not Node.complete?(
      Node.from_sequent([
        %SignedFormula{formula: {:not, :a}, truth_value: true},
        %SignedFormula{formula: :b, truth_value: true}
      ])
    )
  end

  test "Node.closed?" do
    assert not Node.closed?([
      %SignedFormula{formula: :a, truth_value: false}
    ])
    assert not Node.closed?([
      %SignedFormula{formula: :a, truth_value: true}
    ])
    assert not Node.closed?([
      %SignedFormula{formula: :a, truth_value: true},
      %SignedFormula{formula: :b, truth_value: true},
      %SignedFormula{formula: :c, truth_value: false},
      %SignedFormula{formula: :d, truth_value: true}
    ])
    assert Node.closed?([
      %SignedFormula{formula: :a, truth_value: true},
      %SignedFormula{formula: :a, truth_value: false}
    ])
    assert Node.closed?([
      %SignedFormula{formula: :a, truth_value: true},
      %SignedFormula{formula: :b, truth_value: true},
      %SignedFormula{formula: :a, truth_value: false}
    ])
    assert Node.closed?([
      %SignedFormula{formula: {:and, :a, :c}, truth_value: true},
      %SignedFormula{formula: :b, truth_value: true},
      %SignedFormula{formula: {:and, :a, :c}, truth_value: false}
    ])
  end

end
