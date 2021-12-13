defmodule AdventOfCode.Year2021.Day13.Task01 do
  require Integer

  alias AdventOfCode.Year2021.Day13.{
    Submarine
  }

  def solve(input) do
    {matrix, folds} = Submarine.parse_input(input)

    matrix
    |> Submarine.fold(Enum.slice(folds, 0..0))
    |> MapSet.size()
  end
end
