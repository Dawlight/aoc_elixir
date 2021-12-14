defmodule AdventOfCode.Year2021.Day14.Task01 do
  alias AdventOfCode.Year2021.Day14.{
    Submarine
  }

  def solve(input) do
    {start, rules} = Submarine.parse_input(input)

    frequencies =
      for _ <- 1..10, reduce: start do
        polymer ->
          polymerize(polymer, rules, [])
      end
      |> Enum.frequencies()

    {_, min} = frequencies |> Enum.min_by(fn {_, freq} -> freq end)
    {_, max} = frequencies |> Enum.max_by(fn {_, freq} -> freq end)

    max - min
  end

  defp polymerize([last], _rules, buffer), do: buffer ++ [last]

  defp polymerize([a, b | polymer], rules, buffer) do
    case rules[a <> b] do
      nil ->
        polymerize([b | polymer], rules, buffer)

      insert ->
        polymerize([b | polymer], rules, buffer ++ [a, insert])
    end
  end
end
