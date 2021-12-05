defmodule AdventOfCode.Year2021.Day05.Submarine do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " -> ")
      |> Enum.map(fn tuple ->
        [x, y] =
          String.split(tuple, ",")
          |> Enum.map(fn number -> String.to_integer(number) end)

        {x, y}
      end)
    end)
  end

  def get_covered_coordinates([{x1, y1}, {x2, y2}] = line) do
    x_range = x1..x2
    y_range = y1..y2

    case is_cardinal?(line) do
      true -> for x <- x_range, y <- y_range, do: {x, y}
      false -> Enum.zip(x_range, y_range)
    end
  end

  def is_cardinal?([{x1, y1}, {x2, y2}]), do: x1 == x2 or y1 == y2
end
