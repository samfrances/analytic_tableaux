defmodule ValuatorTest do
  use ExUnit.Case
  alias AnalyticTableaux.Valuator

  test "simple atomic formula in conclusion" do
    assert Valuator.value("|-a", %{a: false}) == false
    assert Valuator.value("|-a", %{a: true}) == true
    assert Valuator.value("|-a", %{b: true}) == :unknown
  end

  test "simple atomic formulas in premise and conclusion" do
    assert Valuator.value("a|-a", %{a: true}) == true
    assert Valuator.value("a|-a", %{a: false}) == true
    assert Valuator.value("a|-a", %{b: true}) == :unknown
    assert Valuator.value("b|-a", %{}) == :unknown
    assert Valuator.value("b|-a", %{}) == :unknown
    assert Valuator.value("b|-a", %{a: true}) == true
    assert Valuator.value("b|-a", %{a: false}) == :unknown
    assert Valuator.value("b|-a", %{b: true}) == :unknown
    assert Valuator.value("b|-a", %{b: false}) == true
    assert Valuator.value("b|-a", %{b: true, a: false}) == :false
    assert Valuator.value("b|-a", %{b: false, a: false}) == :true
    assert Valuator.value("b|-a", %{b: false, a: true}) == :true
    assert Valuator.value("b|-a", %{b: true, a: true}) == :true
    assert Valuator.value("a,b|-c", %{a: true,  b: true,  c: true }) == true
    assert Valuator.value("a,b|-c", %{a: false, b: true,  c: true }) == true
    assert Valuator.value("a,b|-c", %{a: true,  b: false, c: true }) == true
    assert Valuator.value("a,b|-c", %{a: false, b: false, c: true }) == true
    assert Valuator.value("a,b|-c", %{b: true, c: true }) == true
    assert Valuator.value("a,b|-c", %{a: true, c: true }) == true
    assert Valuator.value("a,b|-c", %{a: true,  b: true,  c: false}) == false
    assert Valuator.value("a,b|-c", %{a: false, b: true,  c: false}) == true
    assert Valuator.value("a,b|-c", %{a: true,  b: false, c: false}) == true
    assert Valuator.value("a,b|-c", %{a: false, b: false, c: false}) == true
    assert Valuator.value("a,b|-c", %{a: true,  c: false}) == :unknown
    assert Valuator.value("a,b|-c", %{b: true,  c: false}) == :unknown
    assert Valuator.value("a,b|-c", %{a: false,  c: false}) == true
    assert Valuator.value("a,b|-c", %{b: false,  c: false}) == true
  end

  test "conjunctions with atomic children, in conclusion" do
    assert Valuator.value("|-a&b", %{ a: true,  b: true  }) == true
    assert Valuator.value("|-a&b", %{ a: true,  b: false }) == false
    assert Valuator.value("|-a&b", %{ a: false, b: true  }) == false
    assert Valuator.value("|-a&b", %{ a: false, b: false }) == false
    assert Valuator.value("|-a&b", %{ a: true  }) == :unknown
    assert Valuator.value("|-a&b", %{ a: false }) == false
    assert Valuator.value("|-a&b", %{ b: true  }) == :unknown
    assert Valuator.value("|-a&b", %{ b: false }) == false
  end

  test "disjunctions with atomic children, in conclusion" do
    assert Valuator.value("|-a|b", %{ a: true,  b: true  }) == true
    assert Valuator.value("|-a|b", %{ a: true,  b: false }) == true
    assert Valuator.value("|-a|b", %{ a: false, b: true  }) == true
    assert Valuator.value("|-a|b", %{ a: false, b: false }) == false
    assert Valuator.value("|-a|b", %{ a: true  }) == true
    assert Valuator.value("|-a|b", %{ a: false }) == :unknown
    assert Valuator.value("|-a|b", %{ b: true  }) == true
    assert Valuator.value("|-a|b", %{ b: false }) == :unknown
  end

  test "implications with atomic children, in conclusion" do
    assert Valuator.value("|-a->b", %{ a: true,  b: true  }) == true
    assert Valuator.value("|-a->b", %{ a: true,  b: false }) == false
    assert Valuator.value("|-a->b", %{ a: false, b: true  }) == true
    assert Valuator.value("|-a->b", %{ a: false, b: false }) == true
    assert Valuator.value("|-a->b", %{ a: true  }) == :unknown
    assert Valuator.value("|-a->b", %{ a: false }) == true
    assert Valuator.value("|-a->b", %{ b: true  }) == true
    assert Valuator.value("|-a->b", %{ b: false }) == :unknown
  end

  test "biconditionals with atomic children, in conclusion" do
    assert Valuator.value("|-a=b", %{ a: true,  b: true  }) == true
    assert Valuator.value("|-a=b", %{ a: true,  b: false }) == false
    assert Valuator.value("|-a=b", %{ a: false, b: true  }) == false
    assert Valuator.value("|-a=b", %{ a: false, b: false }) == true
    assert Valuator.value("|-a=b", %{ a: true  }) == :unknown
    assert Valuator.value("|-a=b", %{ a: false }) == :unknown
    assert Valuator.value("|-a=b", %{ b: true  }) == :unknown
    assert Valuator.value("|-a=b", %{ b: false }) == :unknown
  end

  test "negation with atomic children, in conclusion" do
    assert Valuator.value("|- ~a", %{ a: true  }) == false
    assert Valuator.value("|- ~a", %{ a: false }) == true
    assert Valuator.value("|- ~a", %{}) == :unknown
  end

  test "more complex example, values to true" do
    sequent = "a&~b,c->a|-b=a"
    valuation = %{
      a: true,
      b: true,
      c: false
    }
    assert Valuator.value(sequent, valuation) == true
  end

  test "more complex example, values to false" do
    sequent = "a&~b,c->a|-b=a"
    valuation = %{
      a: true,
      b: false,
      c: false
    }
    assert Valuator.value(sequent, valuation) == false
  end

end
