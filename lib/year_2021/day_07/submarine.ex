defmodule AdventOfCode.Year2021.Day07.Submarine do
  def parse_input(input) do
    input |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
end
