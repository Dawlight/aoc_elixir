defmodule AdventOfCode.Year2021.Day06.Task02 do
  alias AdventOfCode.Year2021.Day06.{
    Submarine
  }

  def solve(input) do
    Submarine.parse_input(input)
    |> Submarine.simulate_fish_population(256)
  end
end
