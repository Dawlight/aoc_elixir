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

    {matrix, folds}
  end

  def fold(matrix, folds) do
    for fold <- folds, reduce: matrix do
      matrix -> fold_once(matrix, fold)
    end
  end

  defp fold_once(matrix, {x_or_y, column_or_row}) do
    matrix = MapSet.to_list(matrix)

    static_half =
      matrix
      # Coords above/to the left of the fold
      |> Enum.filter(fn c -> c |> get(x_or_y) < column_or_row end)
      |> MapSet.new()

    folded_half =
      matrix
      # Coords beyond the fold
      |> Enum.filter(fn c -> c |> get(x_or_y) > column_or_row end)
      # Normalize
      |> Enum.map(fn c -> c |> set(x_or_y, get(c, x_or_y) - (column_or_row + 1)) end)
      # Flip
      |> Enum.map(fn c -> c |> set(x_or_y, column_or_row - get(c, x_or_y) - 1) end)
      |> MapSet.new()

    # Overlap
    MapSet.union(static_half, folded_half)
  end

  defp get([x, _y], "x"), do: x
  defp get([_x, y], "y"), do: y
  defp set([_x, y], "x", value), do: [value, y]
  defp set([x, _y], "y", value), do: [x, value]

  def inspect_matrix(matrix) when is_list(matrix),
    do: inspect_matrix(matrix |> MapSet.new())

  def inspect_matrix(matrix) do
    max_x = matrix |> Enum.map(fn [x, _y] -> x end) |> Enum.max()
    max_y = matrix |> Enum.map(fn [_x, y] -> y end) |> Enum.max()

    for y <- 0..max_y do
      string =
        for x <- 0..max_x, reduce: "" do
          string ->
            string <> get_at(matrix, x, y)
        end

      IO.puts(string)
    end

    IO.puts("End")
    matrix
  end

  defp get_at(matrix, x, y) do
    case MapSet.member?(matrix, [x, y]) do
      true -> "# "
      false -> ". "
    end
  end
end
