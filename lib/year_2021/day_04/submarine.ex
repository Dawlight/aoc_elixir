defmodule AdventOfCode.Year2021.Day04.Submarine do
  alias AdventOfCode.Year2021.Day04.BingoBoard

  def parse_input(input) do
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

    {numbers, boards}
  end

  def play_bingo(boards, numbers) do
    {_, finished_boards} =
      for number <- numbers, reduce: {boards, []} do
        standings -> announce_number(standings, number)
      end

    finished_boards |> Enum.reverse()
  end

  defp announce_number({boards, finished_boards}, number) do
    non_finished_boards = boards |> Enum.filter(&(!BingoBoard.is_finished?(&1)))

    for board <- non_finished_boards, reduce: {boards, finished_boards} do
      standings -> mark_board(standings, board, number)
    end
  end

  defp mark_board({boards, finished_boards}, board, number) do
    board_index = boards |> Enum.find_index(fn b -> b == board end)
    board = board |> BingoBoard.mark_number(number)
    boards = boards |> List.update_at(board_index, fn _ -> board end)

    case BingoBoard.is_finished?(board) do
      true ->
        {boards, [board | finished_boards]}

      false ->
        {boards, finished_boards}
    end
  end
end
