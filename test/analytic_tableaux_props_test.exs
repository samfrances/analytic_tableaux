defmodule AnalyticTableauxPropsTest do
  use ExUnit.Case
  use PropCheck

  property "an atomic formula proves itself" do
    forall p <- atomic_proposition() do
      AnalyticTableaux.prove("#{p} |- #{p}") |> is_valid()
    end
  end

  property "an atomic formula does not prove its negation" do
    forall p <- atomic_proposition() do
      not (AnalyticTableaux.prove("#{p} |- ~#{p}") |> is_valid())
    end
  end

  property "an atomic formula does not prove another distinct atomic formula" do
    forall p <- atomic_proposition() do
      forall q <- atomic_proposition() do
        implies (p != q) do
          not (AnalyticTableaux.prove("#{p} |- #{q}") |> is_valid())
        end
      end
    end
  end

  def is_valid(result) do
    AnalyticTableaux.get_status(result) == :valid
  end

  # Generators

  def atomic_proposition() do
    let(c <- range(?a, ?z), do: to_string([c]))
  end

end
