defmodule AdventOfCode.Year2021.Day10.Submarine do
  def parse_input(input) do
    String.split(input, "\n") |> Enum.map(&String.trim/1) |> Enum.map(&String.graphemes/1)
  end
end
