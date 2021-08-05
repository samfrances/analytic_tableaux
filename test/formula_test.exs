defmodule FormulaTest do
  use ExUnit.Case

  alias AnalyticTableaux.Formula

  test "should recognize atomic formulas" do
    assert Formula.atomic?(:a)
    assert Formula.atomic?(:b)
    assert Formula.atomic?(:p)
    assert Formula.atomic?(:q)
  end

  test "should recognize complex formulas" do
    assert not Formula.atomic?({:and, :a, :b})
    assert not Formula.atomic?({:or, :a, :b})
    assert not Formula.atomic?({:implies, :a, :b})
    assert not Formula.atomic?({:iff, :a, :b})
    assert not Formula.atomic?({:not, :q})
  end
end
