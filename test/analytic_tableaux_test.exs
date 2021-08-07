defmodule AnalyticTableauxTest do
  use ExUnit.Case

  TestHelpers.SequentExamples.valid()
  |> Enum.each(fn sequent ->
    @tag sequent: sequent
    test "The sequent #{sequent} is valid", context do
      assert AnalyticTableaux.prove(context.sequent).status == :valid
    end
  end)

  TestHelpers.SequentExamples.invalid()
  |> Enum.each(fn sequent ->
    @tag sequent: sequent
    test "The sequent #{sequent} is NOT valid", context do
      assert AnalyticTableaux.prove(context.sequent).status == :not_valid
    end
  end)

end
