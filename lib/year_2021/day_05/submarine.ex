defmodule AdventOfCode.Year2021.Day05.Submarine do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " -> ")
      |> Enum.map(fn tuple -> String.split(tuple, ",") |> Enum.map(&String.to_integer/1) end)
    end)
  end

  def get_covered_coordinates([[x1, y1], [x2, y2]] = line) do
    case is_cardinal?(line) do
      true -> for x <- x1..x2, y <- y1..y2, do: {x, y}
      false -> Enum.zip(x1..x2, y1..y2)
    end
  end

  def is_cardinal?([[x1, y1], [x2, y2]]), do: x1 == x2 or y1 == y2
end
