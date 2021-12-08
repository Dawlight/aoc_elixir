defmodule AdventOfCode.Year2021.Day08.Task01 do
  alias AdventOfCode.Year2021.Day08.{
    Submarine
  }

  def solve(input) do
    numbers_to_count = MapSet.new([1, 4, 7, 8])

    Submarine.parse_input(input)
    |> Submarine.to_numbers()
    |> Enum.map(fn number ->
      number
      |> Integer.to_string()
      |> String.graphemes()
      |> Enum.map(fn grapheme -> String.to_integer(grapheme) end)
    end)
    |> List.flatten()
    |> Enum.count(fn number -> MapSet.member?(numbers_to_count, number) end)
  end
end
