defmodule AnalyticTableaux.CLI do
  def main(args) do
    args
    |> parse_args()
    |> response()
    |> IO.puts()
  end

  defp parse_args(args) do
    args
    |> OptionParser.parse_head(strict: [sequent: :string])
  end

  defp response({[sequent: sequent], _word, _}) do
    result = AnalyticTableaux.prove(sequent)
    status =
      result
      |> AnalyticTableaux.get_status()

    countervaluation =
      result
      |> AnalyticTableaux.get_countervaluation()

      format_result(status, countervaluation)
  end

  defp format_result(status, countervaluation) when countervaluation == %{} do
    format_status(status)
  end

  defp format_result(status, countervaluation) do
    formatted_status = format_status(status)
    formatted_cv = format_countervaluation(countervaluation)
    "#{formatted_status}\n\n#{formatted_cv}"
  end

  defp format_status(status) do
    formatted =
      status
      |> Atom.to_string()
      |> String.replace("_", " ")
    "Status: #{formatted}"
  end

  defp format_countervaluation(cv) do
    cv
    |> Enum.map(fn {k, v} -> "#{Atom.to_string(k)}: #{v}" end)
    |> Enum.join("\n")
  end


end
