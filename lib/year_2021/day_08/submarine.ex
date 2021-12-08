defmodule AdventOfCode.Year2021.Day08.Submarine do
  @default_lookup %{
    0 => nil,
    1 => nil,
    2 => nil,
    3 => nil,
    4 => nil,
    5 => nil,
    6 => nil,
    7 => nil,
    8 => nil,
    9 => nil
  }

  @all_characters ["a", "b", "c", "d", "e", "f", "g"]

  def parse_input(input) do
    data =
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, " | ")
        |> Enum.map(fn chunk ->
          String.split(chunk, " ")
          |> Enum.map(fn combo -> MapSet.new(String.graphemes(combo)) end)
        end)
      end)
      |> IO.inspect(label: "")

    thing =
      for [patterns, output] <- data do
        lookup = get_lookup(patterns) |> IO.inspect(label: "LOOKUP")

        for out <- output do
          Enum.find(lookup, fn {_number, pattern} -> MapSet.equal?(pattern, out) end)
        end
      end

    thing |> IO.inspect(label: "THING")

    for thing2 <- thing do
      thing2 |> IO.inspect(label: "THING")

      for {number, _} <- thing2, reduce: "" do
        grej100 ->
          grej100 <> Integer.to_string(number)
      end
    end
    |> Enum.map(fn thing -> String.to_integer(thing) end)
    |> Enum.sum()
  end

  def get_lookup(patterns) do
    lookup = @default_lookup

    for {number, _} <- lookup, into: %{} do
      {number, lookup_pattern(patterns, number)}
    end
  end

  def lookup_pattern(patterns, 0) do
    pattern_4 = lookup_pattern(patterns, 4)
    pattern_6 = lookup_pattern(patterns, 6)
    nine_six_zero = Enum.filter(patterns, &pattern_with(&1, 6))

    zero_or_nine =
      nine_six_zero
      |> Enum.filter(fn pattern -> !MapSet.equal?(pattern, pattern_6) end)
      |> IO.inspect(label: "ZERO OR NINE")

    zero_or_nine
    |> Enum.find(fn pattern ->
      !MapSet.equal?(MapSet.intersection(pattern_4, pattern), pattern_4)
    end)
  end

  def lookup_pattern(patterns, 1) do
    Enum.find(patterns, fn pattern -> MapSet.size(pattern) == 2 end)
  end

  def lookup_pattern(patterns, 2) do
    {_missing_letter, [pattern_2]} =
      for char <- @all_characters, into: %{} do
        {char, patterns |> Enum.reject(fn pattern -> MapSet.member?(pattern, char) end)}
      end
      |> Enum.find(fn {_missing_letter, patterns} -> length(patterns) == 1 end)

    pattern_2
  end

  def lookup_pattern(patterns, 3) do
    pattern_1 = lookup_pattern(patterns, 1)
    two_three_and_five = Enum.filter(patterns, fn pattern -> MapSet.size(pattern) == 5 end)

    Enum.find(two_three_and_five, fn two_three_or_five ->
      MapSet.size(MapSet.intersection(pattern_1, two_three_or_five)) == 2
    end)
  end

  def lookup_pattern(patterns, 4) do
    Enum.find(patterns, fn pattern -> MapSet.size(pattern) == 4 end)
  end

  def lookup_pattern(patterns, 5) do
    two_and_three = [lookup_pattern(patterns, 2), lookup_pattern(patterns, 3)]

    two_three_and_five = Enum.filter(patterns, &pattern_with(&1, 5))

    Enum.find(two_three_and_five, fn two_three_or_five ->
      !Enum.member?(two_and_three, two_three_or_five)
    end)
  end

  def lookup_pattern(patterns, 6) do
    pattern_1 = lookup_pattern(patterns, 1)

    nine_six_and_zero = Enum.filter(patterns, &pattern_with(&1, 6))

    Enum.find(nine_six_and_zero, fn nine_six_or_zero ->
      MapSet.size(MapSet.intersection(pattern_1, nine_six_or_zero)) == 1
    end)
  end

  def lookup_pattern(patterns, 7) do
    Enum.find(patterns, fn pattern -> MapSet.size(pattern) == 3 end)
  end

  def lookup_pattern(patterns, 8) do
    Enum.find(patterns, fn pattern -> MapSet.size(pattern) == 7 end)
  end

  def lookup_pattern(patterns, 9) do
    pattern_4 = lookup_pattern(patterns, 4)
    pattern_6 = lookup_pattern(patterns, 6)
    nine_six_zero = Enum.filter(patterns, &pattern_with(&1, 6))

    zero_or_nine =
      nine_six_zero
      |> Enum.filter(fn pattern -> !MapSet.equal?(pattern, pattern_6) end)
      |> IO.inspect(label: "ZERO OR NINE")

    zero_or_nine
    |> Enum.find(fn pattern ->
      MapSet.equal?(MapSet.intersection(pattern_4, pattern), pattern_4)
    end)
  end

  def lookup_pattern(_patterns, _) do
    nil
  end

  def pattern_with(pattern, number_of_segments) do
    MapSet.size(pattern) == number_of_segments
  end
end
