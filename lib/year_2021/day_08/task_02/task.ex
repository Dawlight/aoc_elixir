defmodule AdventOfCode.Year2021.Day08.Task02 do
  alias AdventOfCode.Year2021.Day08.{
    Submarine
  }

  def solve(input) do
    Submarine.parse_input(input)
    |> Submarine.to_numbers()
    |> Enum.sum()
  end
end
