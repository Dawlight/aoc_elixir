defmodule AdventOfCode.Year2021.Day07.Task01 do
  alias AdventOfCode.Year2021.Day07.{
    Submarine
  }

  def solve(input) do
    positions = Submarine.parse_input(input)

    max = Enum.max(positions)
    min = Enum.min(positions)

    for(position <- min..max, do: get_cost(positions, position))
    |> Enum.min()
  end

  defp get_cost(positions, target_position) do
    for(position <- positions, do: abs(target_position - position))
    |> Enum.sum()
  end
end
