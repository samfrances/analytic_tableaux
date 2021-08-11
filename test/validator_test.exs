defmodule ValidatorTest do
  use ExUnit.Case
  alias AnalyticTableaux.Validator

  test "simple atomic formula in conclusion" do
    assert Validator.value("|-a", %{a: false}) == false
    assert Validator.value("|-a", %{a: true}) == true
    assert Validator.value("|-a", %{b: true}) == :incomplete_valuation
  end

  test "simple atomic formulas in premise and conclusion" do
    assert Validator.value("a|-a", %{a: true}) == true
    assert Validator.value("a|-a", %{a: false}) == true
    assert Validator.value("a|-a", %{b: true}) == :incomplete_valuation
    assert Validator.value("b|-a", %{}) == :incomplete_valuation
    assert Validator.value("b|-a", %{a: true}) == :incomplete_valuation
    assert Validator.value("b|-a", %{b: true}) == :incomplete_valuation
    assert Validator.value("b|-a", %{b: true, a: false}) == :false
    assert Validator.value("b|-a", %{b: false, a: false}) == :true
    assert Validator.value("b|-a", %{b: false, a: true}) == :true
    assert Validator.value("b|-a", %{b: true, a: true}) == :true
    assert Validator.value("a,b|-c", %{a: true,  b: true,  c: true }) == true
    assert Validator.value("a,b|-c", %{a: false, b: true,  c: true }) == true
    assert Validator.value("a,b|-c", %{a: true,  b: false, c: true }) == true
    assert Validator.value("a,b|-c", %{a: false, b: false, c: true }) == true
    assert Validator.value("a,b|-c", %{a: true,  b: true,  c: false}) == false
    assert Validator.value("a,b|-c", %{a: false, b: true,  c: false}) == true
    assert Validator.value("a,b|-c", %{a: true,  b: false, c: false}) == true
    assert Validator.value("a,b|-c", %{a: false, b: false, c: false}) == true
  end

  test "conjunctions with atomic children, in conclusion" do
    assert Validator.value("|-a&b", %{ a: true,  b: true  }) == true
    assert Validator.value("|-a&b", %{ a: true,  b: false }) == false
    assert Validator.value("|-a&b", %{ a: false, b: true  }) == false
    assert Validator.value("|-a&b", %{ a: false, b: false }) == false
    assert Validator.value("|-a&b", %{ a: true  }) == :incomplete_valuation
    assert Validator.value("|-a&b", %{ a: false }) == :incomplete_valuation
    assert Validator.value("|-a&b", %{ b: true  }) == :incomplete_valuation
    assert Validator.value("|-a&b", %{ b: false }) == :incomplete_valuation
  end

  test "disjunctions with atomic children, in conclusion" do
    assert Validator.value("|-a|b", %{ a: true,  b: true  }) == true
    assert Validator.value("|-a|b", %{ a: true,  b: false }) == true
    assert Validator.value("|-a|b", %{ a: false, b: true  }) == true
    assert Validator.value("|-a|b", %{ a: false, b: false }) == false
    assert Validator.value("|-a|b", %{ a: true  }) == :incomplete_valuation
    assert Validator.value("|-a|b", %{ a: false }) == :incomplete_valuation
    assert Validator.value("|-a|b", %{ b: true  }) == :incomplete_valuation
    assert Validator.value("|-a|b", %{ b: false }) == :incomplete_valuation
  end

  test "implications with atomic children, in conclusion" do
    assert Validator.value("|-a->b", %{ a: true,  b: true  }) == true
    assert Validator.value("|-a->b", %{ a: true,  b: false }) == false
    assert Validator.value("|-a->b", %{ a: false, b: true  }) == true
    assert Validator.value("|-a->b", %{ a: false, b: false }) == true
    assert Validator.value("|-a->b", %{ a: true  }) == :incomplete_valuation
    assert Validator.value("|-a->b", %{ a: false }) == :incomplete_valuation
    assert Validator.value("|-a->b", %{ b: true  }) == :incomplete_valuation
    assert Validator.value("|-a->b", %{ b: false }) == :incomplete_valuation
  end

  test "biconditionals with atomic children, in conclusion" do
    assert Validator.value("|-a=b", %{ a: true,  b: true  }) == true
    assert Validator.value("|-a=b", %{ a: true,  b: false }) == false
    assert Validator.value("|-a=b", %{ a: false, b: true  }) == false
    assert Validator.value("|-a=b", %{ a: false, b: false }) == true
    assert Validator.value("|-a=b", %{ a: true  }) == :incomplete_valuation
    assert Validator.value("|-a=b", %{ a: false }) == :incomplete_valuation
    assert Validator.value("|-a=b", %{ b: true  }) == :incomplete_valuation
    assert Validator.value("|-a=b", %{ b: false }) == :incomplete_valuation
  end

  test "negation with atomic children, in conclusion" do
    assert Validator.value("|- ~a", %{ a: true  }) == false
    assert Validator.value("|- ~a", %{ a: false }) == true
    assert Validator.value("|- ~a", %{}) == :incomplete_valuation
  end

  test "more complex example, values to true" do
    sequent = "a&~b,c->a|-b=a"
    valuation = %{
      a: true,
      b: true,
      c: false
    }
    assert Validator.value(sequent, valuation) == true
  end

  test "more complex example, values to false" do
    sequent = "a&~b,c->a|-b=a"
    valuation = %{
      a: true,
      b: false,
      c: false
    }
    assert Validator.value(sequent, valuation) == false
  end

end
