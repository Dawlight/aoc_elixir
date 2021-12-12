defmodule AdventOfCode.Year2021.Day12.Submarine do
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
  end

  def is_small_cave?(cave) do
    cave == String.downcase(cave)
  end

  def count_paths(node) do
    Enum.reduce(node, 0, fn {_key, value}, count ->
      case value do
        value when is_map(value) -> count + count_paths(value)
        :complete -> count + 1
        :halt -> count
      end
    end)
  end

  def traverse(map, halt_condition), do: traverse(map, "start", ["start"], halt_condition)

  defp traverse(_map, "end", _path, _halt_condition), do: :complete

  defp traverse(map, current, path, halt_condition) do
    case halt_condition.(path) do
      true ->
        :halt

      false ->
        for cave <- connecting_caves(map, current), into: %{} do
          {cave, traverse(map, cave, [cave | path], halt_condition)}
        end
    end
  end

  defp connecting_caves(map, cave) do
    for [from, to] <- map, reduce: [] do
      connections ->
        cond do
          cave == from -> [to | connections]
          cave == to -> [from | connections]
          true -> connections
        end
    end
  end
end
