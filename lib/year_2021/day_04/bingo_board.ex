defmodule AdventOfCode.Year2021.Day04.BingoBoard do
  defstruct grid: nil, marked_numbers: [], is_finished?: false

  def new(grid) do
    %__MODULE__{grid: grid}
  end

  def mark_number(%__MODULE__{marked_numbers: marked_numbers} = board, number) do
    board = %__MODULE__{board | marked_numbers: [number | marked_numbers] |> Enum.uniq()}

    case board |> has_won?() do
      is_finished? -> %__MODULE__{board | is_finished?: is_finished?}
    end
  end

  def calculate_score(%__MODULE__{} = board) do
    %__MODULE__{grid: grid, marked_numbers: marked_numbers} = board

    winning_number = marked_numbers |> List.first()

    marked_numbers = marked_numbers |> MapSet.new()
    grid_numbers = grid |> List.flatten() |> MapSet.new()

    unmarked_numbers_sum =
      MapSet.difference(grid_numbers, marked_numbers)
      |> MapSet.to_list()
      |> Enum.sum()

    winning_number * unmarked_numbers_sum
  end

  def is_finished?(%__MODULE__{is_finished?: is_finished?}), do: is_finished?

  def inspect_board(%__MODULE__{grid: grid, marked_numbers: marked_numbers} = board) do
    for row <- grid do
      for number <- row do
        case marked_numbers |> Enum.member?(number) do
          true -> "X" |> String.pad_leading(2)
          false -> number |> Integer.to_string() |> String.pad_leading(2)
        end
      end
    end
    |> IO.inspect()

    board
  end

  defp has_won?(%__MODULE__{grid: grid} = board) do
    for {row, row_index} <- Enum.with_index(grid), reduce: false do
      has_won? ->
        has_won? =
          for {_, column_index} <- Enum.with_index(row), reduce: has_won? do
            has_won? ->
              has_won? or is_complete_column?(board, column_index)
          end

        has_won? or is_complete_row?(board, row_index)
    end
  end

  defp is_complete_column?(%__MODULE__{} = board, column_index) do
    %__MODULE__{grid: grid, marked_numbers: marked_numbers} = board

    for row <- grid do
      number = row |> Enum.at(column_index)
      marked_numbers |> Enum.member?(number)
    end
    |> Enum.all?()
  end

  defp is_complete_row?(%__MODULE__{} = board, row_index) do
    %__MODULE__{grid: grid, marked_numbers: marked_numbers} = board

    grid
    |> Enum.at(row_index)
    |> Enum.map(fn number -> marked_numbers |> Enum.member?(number) end)
    |> Enum.all?()
  end
end
