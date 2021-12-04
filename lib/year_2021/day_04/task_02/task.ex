defmodule AdventOfCode.Year2021.Day04.Task02 do
  alias AdventOfCode.Year2021.Day04.{
    Submarine,
    BingoBoard
  }

  def solve(input) do
    {numbers, boards} = Submarine.parse_input(input)
    boards = boards |> Enum.map(&BingoBoard.new/1)

    finished_boards = Submarine.play_bingo(boards, numbers)

    finished_boards |> List.last() |> BingoBoard.calculate_score()
  end
end
