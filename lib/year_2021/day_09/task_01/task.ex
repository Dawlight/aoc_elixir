defmodule AdventOfCode.Year2021.Day09.Task01 do
  alias AdventOfCode.Year2021.Day09.{
    Submarine
  }

  def solve(input) do
    matrix = Submarine.parse_input(input)

    Submarine.get_low_points(matrix)
    |> Enum.map(fn {_, height} -> height + 1 end)
    |> Enum.sum()
  end
end
