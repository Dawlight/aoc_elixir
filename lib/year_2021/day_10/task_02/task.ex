defmodule AdventOfCode.Year2021.Day10.Task02 do
  alias AdventOfCode.Year2021.Day10.{
    Submarine
  }

  @points %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

  def solve(input) do
    sequences =
      Submarine.parse_input(input)
      |> Enum.map(&Submarine.parse/1)
      |> Enum.filter(fn result ->
        case result do
          {:incomplete, _} -> true
          _ -> false
        end
      end)
      |> Enum.map(fn result ->
        {:incomplete, sequence} = result
        sequence
      end)
      |> Enum.map(fn sequence -> score_sequence(sequence, 0) end)
      |> Enum.sort()

    mid_pos = (length(sequences) - 1) |> div(2)

    sequences |> Enum.at(mid_pos)
  end

  defp score_sequence([], total), do: total

  defp score_sequence([char | sequence], total) do
    total = total * 5 + @points[char]
    score_sequence(sequence, total)
  end
end
