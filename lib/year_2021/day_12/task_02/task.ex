defmodule AdventOfCode.Year2021.Day12.Task02 do
  alias AdventOfCode.Year2021.Day12.{
    Submarine
  }

  def solve(input) do
    Submarine.parse_input(input)
    |> Submarine.traverse(&continue?/1)
    |> Submarine.count_paths()
  end

  defp continue?(path) do
    frequencies = Enum.frequencies(path)

    start_end_exceeded? =
      frequencies
      |> Enum.any?(fn {cave, frequency} ->
        (cave == "start" or cave == "end") and frequency > 1
      end)

    more_than_two? =
      Enum.any?(frequencies, fn {cave, frequency} ->
        Submarine.is_small_cave?(cave) and frequency > 2
      end)

    twice_small =
      Enum.count(frequencies, fn {cave, frequency} ->
        Submarine.is_small_cave?(cave) and frequency == 2
      end)

    more_than_two? or start_end_exceeded? or twice_small > 1
  end
end
