defmodule AnalyticTableauxTest do
  use ExUnit.Case

  test "The sequent p |- p is valid" do
    sequent = "p |- p"
    assert AnalyticTableaux.prove(sequent).status == :valid
  end

  test "The sequent p |- q is vNOT alid" do
    sequent = "p |- q"
    assert AnalyticTableaux.prove(sequent).status == :not_valid
  end

  test "The sequent p, p->q |- q is valid" do
    sequent = "p, p->q |- q"

    # signed_formulas = generate_signed_formulas(sequent)
    # """
    # T p
    # T p->q
    # F q
    # """

    # Parser.parse(signed_formulas)

    assert AnalyticTableaux.prove(sequent).status == :valid
  end

  test "The sequent p, p->r |- q is NOT valid" do
    sequent = "p, p->r |- q"
    assert AnalyticTableaux.prove(sequent).status == :not_valid
  end

  test "The sequent ~(p&q) |- ~p|~q is valid" do
    sequent = "~(p&q) |- ~p|~q"
    assert AnalyticTableaux.prove(sequent).status == :valid
  end

  test "The sequent p->q, ~q |- ~p is valid" do
    sequent = "p->q, ~q |- ~p"
    assert AnalyticTableaux.prove(sequent).status == :valid
  end

  test "The sequent p=q, ~q |- ~p is valid" do
    sequent = "p=q, ~q |- ~p"
    assert AnalyticTableaux.prove(sequent).status == :valid
  end

  test "The sequent p|q, ~p |- q is valid" do
    sequent = "p|q, ~p |- q"
    assert AnalyticTableaux.prove(sequent).status == :valid
  end

  test "The sequent p|q, ~q |- p is valid" do
    sequent = "p|q, ~p |- q"
    assert AnalyticTableaux.prove(sequent).status == :valid
  end

end
