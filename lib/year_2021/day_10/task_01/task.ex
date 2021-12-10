defmodule AdventOfCode.Year2021.Day10.Task01 do
  alias AdventOfCode.Year2021.Day10.{
    Submarine
  }

  @opening ["[", "(", "{", "<"]
  @closing ["]", ")", "}", ">"]

  @map %{"[" => "]", "(" => ")", "{" => "}", "<" => ">"}

  @points %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

  def solve(input) do
    Submarine.parse_input(input)
    |> Enum.map(fn grapheme -> traverse(grapheme, [], 1) end)
    |> Enum.filter(fn result -> result != :ok end)
    |> Enum.map(fn error ->
      {:syntax_error, {char, _}} = error
      char
    end)
    |> Enum.map(fn char -> @points[char] end)
    |> Enum.sum()
  end

  def traverse([], _map, _) do
    :ok
  end

  def traverse([grapheme | rest], viable, i) when grapheme in @opening do
    traverse(rest, [@map[grapheme] | viable], i + 1)
  end

  def traverse([grapheme | rest], viable, i) when grapheme in @closing do
    [only_viable | viable] = viable

    case only_viable == grapheme do
      true -> traverse(rest, viable, i + 1)
      false -> {:syntax_error, {grapheme, i}}
    end
  end
end
