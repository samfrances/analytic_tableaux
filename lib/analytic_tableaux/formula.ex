defmodule AnalyticTableaux.Formula do

  @type binary_operator ::
    :and | :or | :implies | :if

  @type unary_operator :: :not

  @type formula ::
    atom()
    | {binary_operator, formula, formula}
    | {unary_operator, formula}

  @type t() :: formula

  @spec atomic?(formula) :: boolean
  def atomic?(formula) do
    is_atom(formula)
  end

  @spec pretty_print(formula) :: String.t()
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
