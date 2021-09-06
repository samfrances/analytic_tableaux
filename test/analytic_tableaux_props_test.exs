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

  property "adjunction (&)" do
    forall p <- formula() do
      forall q <- formula() do
        AnalyticTableaux.prove("#{p},#{q} |- #{p}&#{q}") |> is_valid()
      end
    end
  end

  property "simplification (&)" do
    forall p <- formula() do
      forall q <- formula() do
        AnalyticTableaux.prove("#{p}&#{q} |- #{p}") |> is_valid()
        AnalyticTableaux.prove("#{p}&#{q} |- #{q}") |> is_valid()
      end
    end
  end

  property "addition (|)" do
    forall p <- formula() do
      forall q <- formula() do
        AnalyticTableaux.prove("#{p} |- #{p}|#{q}") |> is_valid()
        AnalyticTableaux.prove("#{q} |- #{p}|#{q}") |> is_valid()
      end
    end
  end

  property "case analysis (|)" do
    forall p <- formula() do
      forall q <- formula() do
        forall r <- formula() do
          "#{p}->#{r},#{q}->#{r},#{p}|#{q} |- #{r}"
          |> AnalyticTableaux.prove()
          |> is_valid()
        end
      end
    end
  end

  property "disjunctive syllogism (|)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}|#{q},~#{p} |- #{q}" |> AnalyticTableaux.prove() |> is_valid()
        "#{p}|#{q},~#{q} |- #{p}" |> AnalyticTableaux.prove() |> is_valid()
      end
    end
  end

  property "constructive dilemma (|)" do
    forall p <- formula() do
      forall q <- formula() do
        forall r <- formula() do
          forall s <- formula() do
            "#{p}->#{r},#{q}->#{s},#{p}|#{q} |- #{r}|#{s}"
            |> AnalyticTableaux.prove()
            |> is_valid()
          end
        end
      end
    end
  end

  property "ex contradictione quodlibet (~)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p},~#{p} |- #{q}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "double negation introduction (~)" do
    forall p <- formula() do
      "#{p} |- ~~#{p}"
      |> AnalyticTableaux.prove()
      |> is_valid()
    end
  end

  property "double negation elimination (~)" do
    forall p <- formula() do
      "~~#{p} |- #{p}"
      |> AnalyticTableaux.prove()
      |> is_valid()
    end
  end

  property "reduction ad absurdum (~)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}->#{q},#{p}->~#{q} |- ~#{p}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "biconditional introduction (=)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}->#{q},#{q}->#{p} |- #{p}=#{q}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "biconditional elimination 1 (=)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}=#{q},#{p} |- #{q}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "biconditional elimination 2 (=)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}=#{q},#{q} |- #{p}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "biconditional elimination 3 (=)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}=#{q},~#{p} |- ~#{q}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "biconditional elimination 4 (=)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}=#{q},~#{q} |- ~#{p}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "biconditional elimination 5 (=)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}=#{q},#{q}|#{p} |- #{q}&#{p}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "biconditional elimination 6 (=)" do
    forall p <- formula() do
      forall q <- formula() do
        "#{p}=#{q},~#{q}|~#{p} |- ~#{q}&~#{p}"
        |> AnalyticTableaux.prove()
        |> is_valid()
      end
    end
  end

  property "tautology: A v ~A" do
    forall p <- formula() do
      AnalyticTableaux.prove("|- #{p}|~#{p}") |> is_valid()
    end
  end

  property "tautology: ~(A & ~A)" do
    forall p <- formula() do
      AnalyticTableaux.prove("|- ~(#{p}&~#{p})") |> is_valid()
    end
  end

  property "De Morgan's first law" do
    forall p <- formula() do
      forall q <- formula() do
        left = "~(#{p}|#{q})"
        right = "~#{p}&~#{q}"
        AnalyticTableaux.prove("#{left}  |- #{right}") |> is_valid()
        AnalyticTableaux.prove("#{right} |- #{left}" ) |> is_valid()
      end
    end
  end

  property "De Morgan's second law" do
    forall p <- formula() do
      forall q <- formula() do
        left = "~(#{p}&#{q})"
        right = "~#{p}|~#{q}"
        AnalyticTableaux.prove("#{left}  |- #{right}") |> is_valid()
        AnalyticTableaux.prove("#{right} |- #{left}" ) |> is_valid()
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
