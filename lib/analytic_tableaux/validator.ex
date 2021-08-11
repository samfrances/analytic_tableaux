defmodule AnalyticTableaux.Validator do
  alias AnalyticTableaux.Parser

  def value(sequent, valuation = %{}) do
    Parser.parse(sequent)
    |> value_parsed_sequent(valuation)
  end

  # defp value_parsed_sequent([conclusion], valuation = %{}) do
  #   value_formula(conclusion, valuation)
  # end

  defp value_parsed_sequent(sequent, valuation = %{}) when length(sequent) >= 1 do
    premises = Enum.slice(sequent, 0..-2)
    conclusion = Enum.at(sequent, -1)
    value_formula(conclusion, valuation)
    |> value_argument(value_premises(premises, valuation), premises)
  end

  defp value_argument(
    conclusion_value,
    premises_value,
    _premises
  ) when conclusion_value == :unknown or premises_value == :unknown do
    :unknown
  end

  defp value_argument(conclusion_value, _premises_value, _premises = []) do
    conclusion_value
  end

  defp value_argument(_conclusion_value = true, _premises_value, _premises) do
    true
  end

  defp value_argument(_conclusion_value, _premises_value = false, _premises) do
    true
  end

  defp value_argument(_conclusion_value, _premises_value, _premises) do
    false
  end

  defp value_premises(premises, valuation) do
    valued =
      premises
      |> Enum.map(fn f -> value_formula(f, valuation) end)
    if Enum.any?(valued, fn v -> v == :unknown end) do
      :unknown
    else
      Enum.all?(valued)
    end
  end

  defp value_formula(f, valuation) when is_atom(f) do
    Map.get(valuation, f, :unknown)
  end

end
