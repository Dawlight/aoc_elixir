defmodule AdventOfCode.Year2021.Day05.Task01 do
  alias AdventOfCode.Year2021.Day05.{
    Submarine
  }

  def solve(input) do
    Submarine.parse_input(input)
    |> Enum.filter(&Submarine.is_cardinal?/1)
    |> Enum.flat_map(&Submarine.get_covered_coordinates/1)
    |> Enum.frequencies()
    |> Enum.filter(fn {_, frequency} -> frequency >= 2 end)
    |> Enum.count()
  end
end
