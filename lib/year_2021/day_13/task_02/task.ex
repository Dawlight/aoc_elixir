defmodule AdventOfCode.Year2021.Day13.Task02 do
  alias AdventOfCode.Year2021.Day13.{
    Submarine
  }

  def solve(input) do
    {matrix, folds} = Submarine.parse_input(input)

    matrix
    |> Submarine.fold(folds)
    |> Submarine.inspect_matrix()
  end
end
