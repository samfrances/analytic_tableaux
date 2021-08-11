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

end
