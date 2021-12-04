defmodule AdventOfCode.Year2021.Day04.Task01 do
  def solve(input) do
    [numbers | boards] = input |> String.split("\n\n", trim: true)

    numbers =
      numbers
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.map(fn board ->
        board
        |> String.split("\n", trim: true)
        |> Enum.map(fn row ->
          row
          |> String.split([" ", "  "], trim: true)
          |> Enum.map(fn column -> column |> String.to_integer(10) end)
        end)
      end)

    result =
      for number <- numbers,
          board <- boards,
          reduce: {MapSet.new(), nil, nil} do
        {marked_numbers, nil, nil} ->
          marked_numbers = marked_numbers |> MapSet.put(number)

          case has_board_won?(board, marked_numbers) do
            true ->
              {marked_numbers, board, number}

            false ->
              {marked_numbers, nil, nil}
          end

        {marked_numbers, winning_board, winning_number} ->
          {marked_numbers, winning_board, winning_number}
      end

    {marked_numbers, winning_board, winning_number} = result

    winning_numbers = winning_board |> List.flatten() |> MapSet.new()
    marked_numbers = MapSet.new(marked_numbers)

    sum = MapSet.difference(winning_numbers, marked_numbers) |> MapSet.to_list() |> Enum.sum()

    winning_number * sum
  end

  defp has_board_won?(board, marked_numbers) do
    for {row, row_index} <- Enum.with_index(board), reduce: false do
      has_won? ->
        has_won? =
          for {_, column_index} <- Enum.with_index(row), reduce: has_won? do
            has_won? ->
              has_won? or is_winning_column?(board, column_index, marked_numbers)
          end

        has_won? or is_winning_row?(board, row_index, marked_numbers)
    end
  end

  defp is_winning_column?(board, column_index, marked_numbers) do
    for row <- board do
      number = row |> Enum.at(column_index)
      marked_numbers |> MapSet.member?(number)
    end
    |> Enum.all?()
  end

  defp is_winning_row?(board, row_index, marked_numbers) do
    row = board |> Enum.at(row_index)

    row |> Enum.map(fn number -> marked_numbers |> MapSet.member?(number) end) |> Enum.all?()
  end
end
