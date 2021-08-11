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

end
