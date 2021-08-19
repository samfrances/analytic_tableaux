defmodule OldProblemGenerator do
  #  https://github.com/adolfont/KEMS/tree/master/kems.problems

  def generate(problem, n) do
    generate_left_side(problem, n) <>
      " |- " <>
      generate_right_side(problem, n)
  end

  defp generate_left_side(_, n) do
    1..(n + 1)
    |> Enum.map(fn x -> generate_left_side_subformula(x, n) end)
    |> Enum.join("&")
    |> add_external_parentheses(n+1)
  end

  defp add_external_parentheses(string, n) when n > 1 do
    "(#{string})"
  end

  defp add_external_parentheses(string, _) do
    "#{string}"
  end

  defp generate_left_side_subformula(i, n) do
    1..n
    |> Enum.map(fn x -> "p#{i}_#{x}" end)
    |> Enum.join("|")
    |> add_external_parentheses(n)
  end

  defp generate_right_side(:php, n) do
    for pigeonhole <- 1..n, [i, j] <- envelope_pairings(n) do
      {pigeonhole, i, j}
    end
    |> Enum.map(fn {ph, i, j} -> "(p#{i}_#{ph}&p#{j}_#{ph})" end)
    |> Enum.join("|")
    |> add_external_parentheses(n)
  end

  defp envelope_pairings(n) do
    for i <- 1..(n+1), j <- 1..(n+1) do
      [i, j]
    end
    |> Enum.reject(fn [i, j] -> j <= i end)
    # |> Enum.reject(fn [i, j] -> j - i > 2 end)
  end

end
