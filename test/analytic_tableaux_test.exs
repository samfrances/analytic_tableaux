defmodule AnalyticTableauxTest do
  use ExUnit.Case

  alias AnalyticTableaux.Valuator
  import AnalyticTableaux

  TestHelpers.SequentExamples.valid()
  |> Enum.each(fn sequent ->
    @tag sequent: sequent
    test "The sequent #{sequent} is valid", context do
      assert prove(context.sequent) |> get_status() == :valid
    end
  end)

  TestHelpers.SequentExamples.invalid()
  |> Enum.each(fn sequent ->
    @tag sequent: sequent
    test "The sequent #{sequent} is NOT valid", context do
      result = prove(context.sequent)
      assert result |> get_status() == :not_valid
      countervaluation = result |> get_countervaluation()
      assert Valuator.value(context.sequent, countervaluation) == false
    end
  end)

end
