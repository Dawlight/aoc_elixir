defmodule AdventOfCode.Year2021.Day12.Task01 do
  alias AdventOfCode.Year2021.Day12.{
    Submarine
  }

  def solve(input) do
    Submarine.parse_input(input)
    |> Submarine.traverse(&continue?/1)
    |> Submarine.count_paths()
  end

  defp continue?(path) do
    Enum.frequencies(path)
    |> Enum.any?(fn {cave, frequency} ->
      Submarine.is_small_cave?(cave) && frequency > 1
    end)
  end
end
