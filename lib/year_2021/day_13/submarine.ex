defmodule AdventOfCode.Year2021.Day13.Submarine do
  def parse_input(input) do
    [dots, folds] = input |> String.split("\n\n")

    matrix =
      dots
      |> String.split("\n", trim: true)
      |> Enum.map(fn coord_string ->
        coord_string
        |> String.split(",", trim: true)
        |> Enum.map(fn number -> String.to_integer(number) end)
      end)
      |> MapSet.new()

    folds =
      folds
      |> String.split("\n")
      |> Enum.map(fn "fold along " <> instruction ->
        [axis, coordinate] = instruction |> String.split("=")
        {axis, coordinate |> String.to_integer()}
      end)

    {matrix, folds} |> IO.inspect(label: "WOW")
  end
end
