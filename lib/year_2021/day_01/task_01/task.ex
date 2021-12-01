defmodule AdventOfCode.Year2021.Day01.Task01 do
  alias AdventOfCode.Year2021.Day01.Submarine

  def solve(input) do
    measurements = input |> Enum.map(fn line -> elem(Integer.parse(line), 0) end)
    Submarine.get_increases(measurements, 1)
  end
end
