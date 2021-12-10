defmodule AdventOfCode.Year2021.Day10.Submarine do
  @opening ["[", "(", "{", "<"]
  @closing ["]", ")", "}", ">"]
  @closing_map %{"[" => "]", "(" => ")", "{" => "}", "<" => ">"}

  def parse_input(input) do
    String.split(input, "\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end

  def parse(chunk) do
    do_parse(chunk, [], 1)
  end

  defp do_parse([], [], _) do
    :ok
  end

  defp do_parse([], closing, _) do
    {:incomplete, closing}
  end

  defp do_parse([char | chunk], closing, i) when char in @opening do
    do_parse(chunk, [@closing_map[char] | closing], i + 1)
  end

  defp do_parse([char | chunk], closing, i) when char in @closing do
    [closing_char | closing] = closing

    case closing_char == char do
      true -> do_parse(chunk, closing, i + 1)
      false -> {:syntax_error, {char, i}}
    end
  end
end
