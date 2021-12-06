defmodule AdventOfCode.Year2021.Day06.Submarine do
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def simulate_fish_population(input, days) do
    fish_by_age = input |> Enum.frequencies()

    Enum.reduce(1..days, fish_by_age, fn _day, fish_by_age -> simulate_day(fish_by_age) end)
    |> Enum.map(fn {_age, count} -> count end)
    |> Enum.sum()
  end

  def simulate_day(fish_by_age) do
    fish_by_age =
      for {age, fish} <- fish_by_age, reduce: %{} do
        fish_by_age -> fish_by_age |> Map.put(age - 1, fish)
      end

    {new_fish, fish_by_age} = fish_by_age |> Map.pop(-1, 0)
    newly_pregnant_fish = new_fish

    fish_by_age
    |> Map.update(6, newly_pregnant_fish, fn fish -> fish + newly_pregnant_fish end)
    |> Map.update(8, new_fish, fn fish -> fish + new_fish end)
  end
end
