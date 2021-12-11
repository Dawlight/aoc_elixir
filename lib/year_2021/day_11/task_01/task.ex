defmodule AdventOfCode.Year2021.Day11.Task01 do
  alias AdventOfCode.Year2021.Day11.{
    Submarine
  }

  def solve(input) do
    IO.puts("START")

    Submarine.parse_input(input)
    |> Submarine.print_matrix()
    |> Submarine.simulate(1000)
  end
end
