defmodule AdventOfCode.Year2021.Day15.Submarine do
  def parse_input(input) do
    rows =
      input
      |> String.split("\n")
      |> Enum.map(fn row ->
        row
        |> String.graphemes()
        |> Enum.map(fn grapheme -> String.to_integer(grapheme) end)
      end)

    for {row, y} <- Enum.with_index(rows),
        {number, x} <- Enum.with_index(row),
        into: %{},
        do: {{x, y}, number}
  end
end
