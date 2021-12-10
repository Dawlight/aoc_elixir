defmodule AdventOfCode.Year2021.Day10.Task01 do
  alias AdventOfCode.Year2021.Day10.{
    Submarine
  }

  @points %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

  def solve(input) do
    Submarine.parse_input(input)
    |> Enum.map(&Submarine.parse/1)
    |> Enum.filter(fn result ->
      case result do
        {:syntax_error, _} -> true
        _ -> false
      end
    end)
    |> Enum.map(fn {:syntax_error, {char, _}} -> char end)
    |> Enum.map(fn char -> @points[char] end)
    |> Enum.sum()
  end
end
