defmodule AdventOfCode.Year2021.Day09.Task02 do
  alias AdventOfCode.Year2021.Day09.{
    Submarine
  }

  def solve(input) do
    matrix = Submarine.parse_input(input)

    Submarine.get_basins(matrix)
    |> Enum.map(&length/1)
    |> Enum.sort_by(& &1, :desc)
    |> Enum.slice(0..2)
    |> Enum.product()
  end
end
