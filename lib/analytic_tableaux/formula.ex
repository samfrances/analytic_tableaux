defmodule AnalyticTableaux.Formula do

  def atomic?(formula) do
    is_atom(formula)
  end

  def pretty_print(formula) when is_atom(formula) do
    to_string(formula)
  end

  def pretty_print({:and, a, b}) do
    "(#{pretty_print(a)} & #{pretty_print(b)})"
  end

  def pretty_print({:or, a, b}) do
    "(#{pretty_print(a)} | #{pretty_print(b)})"
  end

  def pretty_print({:implies, a, b}) do
    "(#{pretty_print(a)} → #{pretty_print(b)})"
  end

  def pretty_print({:iff, a, b}) do
    "(#{pretty_print(a)} = #{pretty_print(b)})"
  end

  def pretty_print({:not, a}) do
    "~#{pretty_print(a)}"
  end

end
