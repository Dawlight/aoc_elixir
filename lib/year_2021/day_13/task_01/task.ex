defmodule AdventOfCode.Year2021.Day13.Task01 do
  require Integer

  alias AdventOfCode.Year2021.Day13.{
    Submarine
  }

  def solve(input) do
    Submarine.parse_input(input) |> fold() |> MapSet.size()
  end

  def fold({matrix, folds}) do
    matrix |> inspect_matrix() |> MapSet.size() |> IO.inspect(label: "DOTS")
    max_x = matrix |> Enum.map(fn [x, _y] -> x end) |> Enum.max() |> IO.inspect(label: "MAX X")
    max_y = matrix |> Enum.map(fn [_x, y] -> y end) |> Enum.max() |> IO.inspect(label: "MAX Y")

    folds
    # |> Enum.slice(0..0)
    |> IO.inspect(label: "FOLDS")
    |> Enum.reduce(matrix, fn fold, matrix -> one_fold(matrix, fold) end)
    |> inspect_matrix()

    # matrix = one_fold(matrix, folds |> List.first()) |> inspect_matrix()
  end

  def one_fold(matrix, {"x", column}) do
    original_max_x = matrix |> Enum.map(fn [x, _y] -> x end) |> Enum.max()

    right_half =
      Enum.filter(matrix |> MapSet.to_list(), fn [x, _y] -> x > column end)
      |> Enum.map(fn [x, y] -> [x - (column + 1), y] end)

    IO.puts("UPPER")

    left_half =
      Enum.filter(matrix |> MapSet.to_list(), fn [x, _y] -> x < column end) |> MapSet.new()

    max_x = Enum.map(right_half, fn [x, _y] -> x end) |> Enum.max()

    IO.puts("BOTTOM")

    right_half =
      Enum.map(right_half, fn [x, y] -> [column - x - 1, y] end)
      |> MapSet.new()

    MapSet.union(right_half, left_half)
  end

  def one_fold(matrix, {"y", row}) do
    original_max_y = matrix |> Enum.map(fn [_x, y] -> y end) |> Enum.max()

    bottom_half =
      Enum.filter(matrix |> MapSet.to_list(), fn [_x, y] -> y > row end)
      |> Enum.map(fn [x, y] -> [x, y - (row + 1)] end)

    IO.puts("UPPER")

    upper_half =
      Enum.filter(matrix |> MapSet.to_list(), fn [_x, y] -> y < row end) |> MapSet.new()

    max_y = Enum.map(bottom_half, fn [_x, y] -> y end) |> Enum.max()

    IO.puts("BOTTOM")

    bottom_half =
      Enum.map(bottom_half, fn [x, y] -> [x, row - y - 1] end)
      |> MapSet.new()

    MapSet.union(bottom_half, upper_half)
  end

  defp inspect_matrix(matrix) when is_list(matrix),
    do: inspect_matrix(matrix |> MapSet.new())

  defp inspect_matrix(matrix) do
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
