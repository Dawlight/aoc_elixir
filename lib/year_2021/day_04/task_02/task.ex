defmodule AdventOfCode.Year2021.Day04.Task02 do
  def solve(input) do
    [numbers | boards] = input |> String.split("\n\n", trim: true)

    numbers =
      numbers
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    Enum.count(numbers) |> IO.inspect(label: "NUMBER OF NUBMERS")

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
      for number <- numbers, reduce: {MapSet.new(), [], []} do
        {marked_numbers, _, _} = results ->
          marked_numbers = marked_numbers |> MapSet.put(number)

          for board <- boards, reduce: results do
            {_, winning_boards, winning_numbers} when length(winning_boards) == length(boards) ->
              {marked_numbers, winning_boards, winning_numbers}

            {_, winning_boards, winning_numbers} ->
              board_has_already_won? =
                winning_boards |> Enum.find(fn {_, board_that_won} -> board_that_won == board end)

              case has_board_won?(board, marked_numbers) and !board_has_already_won? do
                true ->
                  inspect_board(board, marked_numbers)

                  {marked_numbers, [{marked_numbers, board} | winning_boards],
                   [number | winning_numbers]}

                false ->
                  {marked_numbers, winning_boards, winning_numbers}
              end
          end
      end

    {_, winning_boards, winning_numbers} = result

    {marked_numbers, winning_board} =
      winning_boards |> List.first() |> IO.inspect(label: "MARKED NUBMERS", limit: :infinity)

    winning_board |> inspect_board(marked_numbers)

    winning_number = winning_numbers |> List.first() |> IO.inspect(label: "WINNING NUMBER")

    winning_numbers = winning_board |> List.flatten() |> MapSet.new()
    marked_numbers = MapSet.new(marked_numbers)

    sum =
      MapSet.difference(winning_numbers, marked_numbers)
      |> MapSet.to_list()
      |> Enum.sum()
      |> IO.inspect(label: "DIFFERENCE")

    winning_number * sum
  end

  def inspect_board(board, marked_numbers) do
    for row <- board do
      for number <- row do
        case marked_numbers |> MapSet.member?(number) do
          true -> "X" |> String.pad_leading(2)
          false -> number |> Integer.to_string() |> String.pad_leading(2)
        end
      end
    end
    |> IO.inspect(label: "BOARD")
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
