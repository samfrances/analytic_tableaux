defmodule AnalyticTableaux.Validator do
  alias AnalyticTableaux.Parser

  def value(sequent, valuation = %{}) do
    truth_values =
      Parser.parse(sequent)
      |> Enum.map(fn f -> value_formula(f, valuation) end)
    if :unknown in truth_values do
      :unknown
    else
      value(truth_values)
    end
  end

  defp value([conclusion_value]) do
    conclusion_value
  end

  defp value(truth_values) do
    premises = Enum.slice(truth_values, 0..-2)
    conclusion = Enum.at(truth_values, -1)
    not Enum.all?(premises) || conclusion
  end

  defp value_formula(f, valuation) when is_atom(f) do
    Map.get(valuation, f, :unknown)
  end

  defp value_formula({op, a, b}, valuation) do
    left_side = value_formula(a, valuation)
    right_side = value_formula(b, valuation)
    if :unknown in [left_side, right_side] do
      :unknown
    else
      value_binary({op, left_side, right_side})
    end
  end

  defp value_formula({:not, a}, valuation) do
    a_val = value_formula(a, valuation)
    if a_val == :unknown do
      a_val
    else
      not a_val
    end
  end

  defp value_binary({:and, a_val, b_val}) do
    a_val and b_val
  end

  defp value_binary({:or, a_val, b_val}) do
    a_val or b_val
  end

  defp value_binary({:implies, a_val, b_val}) do
    (not a_val) or b_val
  end

  defp value_binary({:iff, a_val, b_val}) do
    a_val == b_val
  end

end
