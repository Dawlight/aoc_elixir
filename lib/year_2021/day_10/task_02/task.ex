defmodule AdventOfCode.Year2021.Day10.Task02 do
  alias AdventOfCode.Year2021.Day10.{
    Submarine
  }

  @opening ["[", "(", "{", "<"]
  @closing ["]", ")", "}", ">"]

  @map %{"[" => "]", "(" => ")", "{" => "}", "<" => ">"}

  @points %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

  def solve(input) do
    sequences =
      Submarine.parse_input(input)
      |> Enum.map(fn grapheme -> traverse(grapheme, [], 1) end)
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
    total = total * 5
    total = total + @points[char]
    score_sequence(sequence, total)
  end

  def traverse([], [], _) do
    :ok
  end

  def traverse([], closing, _) do
    {:incomplete, closing}
  end

  def traverse([grapheme | rest], closing, i) when grapheme in @opening do
    traverse(rest, [@map[grapheme] | closing], i + 1)
  end

  def traverse([grapheme | rest], closing, i) when grapheme in @closing do
    [accepted_closing | closing] = closing

    case accepted_closing == grapheme do
      true -> traverse(rest, closing, i + 1)
      false -> {:syntax_error, {grapheme, i}}
    end
  end
end
