defmodule AdventOfCode.Year2021.Day07.Task02 do
  alias AdventOfCode.Year2021.Day07.{
    Submarine
  }

  def solve(input) do
    positions = Submarine.parse_input(input)

    max = Enum.max(positions)
    min = Enum.min(positions)

    Task.async_stream(min..max, fn position -> get_cost(positions, position) end)
    |> Enum.map(fn {:ok, result} -> result end)
    |> Enum.min()
  end

  defp get_cost(positions, target_position) do
    for position <- positions do
      abs(target_position - position)
      |> get_distance_cost()
    end
    |> Enum.sum()
  end

  def get_distance_cost(distance) do
    for step <- 1..distance, reduce: 0 do
      cost -> cost + step
    end
  end
end
