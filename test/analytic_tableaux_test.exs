defmodule AnalyticTableauxTest do
  use ExUnit.Case
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
      assert prove(context.sequent) |> get_status() == :not_valid
    end
  end)

end
