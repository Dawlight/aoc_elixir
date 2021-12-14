defmodule AdventOfCode.Year2021.Day14.Submarine do
  def parse_input(input) do
    [start, rules] = input |> String.split("\n\n", trim: true)
    start = start |> String.graphemes()

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(fn string ->
        [rule, insert] = String.split(string, " -> ", trim: true)
        {rule, insert}
      end)
      |> Map.new()

    {start, rules}
  end
end
