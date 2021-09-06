defmodule AnalyticTableauxPropsTest do
  use ExUnit.Case
  use PropCheck

  property "a simple formula proves itself" do
    forall p <- simple_formula() do
      AnalyticTableaux.prove("#{p} |- #{p}") |> is_valid()
    end
  end

  property "a formula without negation proves itself" do
    forall p <- formula_without_negation() do
      AnalyticTableaux.prove("#{p} |- #{p}") |> is_valid()
    end
  end

  property "a simple formula does not prove its negation" do
    forall p <- simple_formula() do
      not (AnalyticTableaux.prove("#{p} |- ~#{p}") |> is_valid())
    end
  end

  property "a formula-without-negation does not prove its negation" do
    forall p <- formula_without_negation() do
      not (AnalyticTableaux.prove("#{p} |- ~#{p}") |> is_valid())
    end
  end

  property "a simple formula does not prove another distinct simple formula" do
    forall p <- simple_formula() do
      forall q <- simple_formula() do
        implies (p != q) do
          not (AnalyticTableaux.prove("#{p} |- #{q}") |> is_valid())
        end
      end
    end
  end

  property "modus ponens" do
    forall p <- formula() do
      forall q <- formula() do
        AnalyticTableaux.prove("#{p}->#{q},#{p} |- #{q}") |> is_valid()
      end
    end
  end

  property "modus tollens" do
    forall p <- formula() do
      forall q <- formula() do
        AnalyticTableaux.prove("#{p}->#{q},~#{q} |- ~#{p}") |> is_valid()
      end
    end
  end

  def is_valid(result) do
    AnalyticTableaux.get_status(result) == :valid
  end

  # Generators

  def simple_formula() do
    let({c, b} <- {atomic_formula(), boolean()}, do: simple_formula_to_string(c, b))
  end

  def simple_formula_to_string(c, true), do: c
  def simple_formula_to_string(c, false), do: "~#{c}"

  defp atomic_formula() do
    let(c <- range(?a, ?z), do: to_string([c]))
  end

  defp binary_connective() do
    oneof(["&", "|", "->"])
  end

  def formula_without_negation() do
    sized(size, formula_without_negation(size))
  end

  defp formula_without_negation(0) do
    atomic_formula()
  end

  defp formula_without_negation(size) do
    frequency([
      {1, atomic_formula()},
      {
        7,
        let_shrink([
          f1 <- formula_without_negation(size |> div(3)),
          f2 <- formula_without_negation(size |> div(3)),
          b  <- binary_connective()
        ]) do
          "(#{f1}#{b}#{f2})"
        end
      }
    ])
  end

  def formula() do
    sized(size, formula(size))
  end

  defp formula(0) do
    simple_formula()
  end

  defp formula(size) do
    frequency([
      {1, simple_formula()},
      {
        7,
        let_shrink([
          f1 <- formula(size |> div(3)),
          f2 <- formula(size |> div(3)),
          b  <- binary_connective()
        ]) do
          "(#{f1}#{b}#{f2})"
        end
      }
    ])
  end

end
