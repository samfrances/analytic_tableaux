defmodule AnalyticTableaux.Validator do
  alias AnalyticTableaux.Parser

  def value(sequent, valuation = %{}) do
    Parser.parse(sequent)
    |> Enum.map(fn f -> value_formula(f, valuation) end)
    |> value()
  end

  defp value([conclusion_value]) do
    conclusion_value
  end

  defp value(truth_values) do
    premises = Enum.slice(truth_values, 0..-2)
    conclusion = Enum.at(truth_values, -1)
    cond do
      conclusion == true     -> true
      conclusion == :unknown -> any_false?(premises) || :unknown
      any_false?(premises)   -> true
      all_true?(premises)    -> false
      true                   -> :unknown
    end
  end

  defp any_false?(premises) do
    Enum.any?(premises, fn i -> i == false end)
  end

  defp all_true?(premises) do
    Enum.all?(premises, fn p -> p == true end)
  end

  defp value_formula(f, valuation) when is_atom(f) do
    Map.get(valuation, f, :unknown)
  end

  defp value_formula({op, a, b}, valuation) do
    left_side = value_formula(a, valuation)
    right_side = value_formula(b, valuation)
    value_binary({op, left_side, right_side})
  end

  defp value_formula({:not, a}, valuation) do
    a_val = value_formula(a, valuation)
    if a_val == :unknown do
      a_val
    else
      not a_val
    end
  end

  defp value_binary({:and, _, false}), do: false
  defp value_binary({:and, false, _}), do: false
  defp value_binary({:and, :unknown, _}), do: :unknown
  defp value_binary({:and, _, :unknown}), do: :unknown
  defp value_binary({:and, a_val, b_val}) do
    a_val and b_val
  end

  defp value_binary({:or, true, _}), do: true
  defp value_binary({:or, _, true}), do: true
  defp value_binary({:or, _, :unknown}), do: :unknown
  defp value_binary({:or, :unknown, _}), do: :unknown
  defp value_binary({:or, a_val, b_val}) do
    a_val or b_val
  end

  defp value_binary({:implies, _, true}), do: true
  defp value_binary({:implies, false, _}), do: true
  defp value_binary({:implies, _, :unknown}), do: :unknown
  defp value_binary({:implies, :unknown, false}), do: :unknown
  defp value_binary({:implies, a_val, b_val}) do
    (not a_val) or b_val
  end

  defp value_binary({:iff, :unknown, _}), do: :unknown
  defp value_binary({:iff, _, :unknown}), do: :unknown
  defp value_binary({:iff, a_val, b_val}) do
    a_val == b_val
  end

end
