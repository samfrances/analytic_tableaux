defmodule ValidatorTest do
  use ExUnit.Case
  alias AnalyticTableaux.Validator

  test "simple atomic formula in conclusion" do
    assert Validator.value("|-a", %{a: false}) == false
    assert Validator.value("|-a", %{a: true}) == true
    assert Validator.value("|-a", %{b: true}) == :unknown
  end

  test "simple atomic formulas in premise and conclusion" do
    assert Validator.value("a|-a", %{a: true}) == true
    assert Validator.value("a|-a", %{a: false}) == true
    assert Validator.value("a|-a", %{b: true}) == :unknown
    assert Validator.value("b|-a", %{}) == :unknown
    assert Validator.value("b|-a", %{a: true}) == :unknown
    assert Validator.value("b|-a", %{b: true}) == :unknown
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
    assert Validator.value("|-a&b", %{ a: true  }) == :unknown
    assert Validator.value("|-a&b", %{ a: false }) == :unknown
    assert Validator.value("|-a&b", %{ b: true  }) == :unknown
    assert Validator.value("|-a&b", %{ b: false }) == :unknown
  end

  test "disjunctions with atomic children, in conclusion" do
    assert Validator.value("|-a|b", %{ a: true,  b: true  }) == true
    assert Validator.value("|-a|b", %{ a: true,  b: false }) == true
    assert Validator.value("|-a|b", %{ a: false, b: true  }) == true
    assert Validator.value("|-a|b", %{ a: false, b: false }) == false
    assert Validator.value("|-a|b", %{ a: true  }) == :unknown
    assert Validator.value("|-a|b", %{ a: false }) == :unknown
    assert Validator.value("|-a|b", %{ b: true  }) == :unknown
    assert Validator.value("|-a|b", %{ b: false }) == :unknown
  end

  test "implications with atomic children, in conclusion" do
    assert Validator.value("|-a->b", %{ a: true,  b: true  }) == true
    assert Validator.value("|-a->b", %{ a: true,  b: false }) == false
    assert Validator.value("|-a->b", %{ a: false, b: true  }) == true
    assert Validator.value("|-a->b", %{ a: false, b: false }) == true
    assert Validator.value("|-a->b", %{ a: true  }) == :unknown
    assert Validator.value("|-a->b", %{ a: false }) == :unknown
    assert Validator.value("|-a->b", %{ b: true  }) == :unknown
    assert Validator.value("|-a->b", %{ b: false }) == :unknown
  end

  test "biconditionals with atomic children, in conclusion" do
    assert Validator.value("|-a=b", %{ a: true,  b: true  }) == true
    assert Validator.value("|-a=b", %{ a: true,  b: false }) == false
    assert Validator.value("|-a=b", %{ a: false, b: true  }) == false
    assert Validator.value("|-a=b", %{ a: false, b: false }) == true
    assert Validator.value("|-a=b", %{ a: true  }) == :unknown
    assert Validator.value("|-a=b", %{ a: false }) == :unknown
    assert Validator.value("|-a=b", %{ b: true  }) == :unknown
    assert Validator.value("|-a=b", %{ b: false }) == :unknown
  end

  test "negation with atomic children, in conclusion" do
    assert Validator.value("|- ~a", %{ a: true  }) == false
    assert Validator.value("|- ~a", %{ a: false }) == true
    assert Validator.value("|- ~a", %{}) == :unknown
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
