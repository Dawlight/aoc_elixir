defmodule AdventOfCode.Year2021.Day08.Submarine do
  @all_characters ["a", "b", "c", "d", "e", "f", "g"]

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, " | ")
      |> Enum.map(fn chunk ->
        String.split(chunk, " ")
        |> Enum.map(fn combo -> MapSet.new(String.graphemes(combo)) end)
      end)
    end)
  end

  def to_numbers(data) do
    baked_lines =
      for [patterns, output] <- data do
        lookup = generate_lookup(patterns)

        for out <- output do
          Enum.find(lookup, fn {_number, pattern} -> MapSet.equal?(pattern, out) end)
        end
      end

    for baked_line <- baked_lines do
      for {number, _} <- baked_line, reduce: "" do
        number_string ->
          number_string <> Integer.to_string(number)
      end
    end
    |> Enum.map(fn number_string -> String.to_integer(number_string) end)
  end

  def generate_lookup(patterns) do
    for number <- 0..9, into: %{} do
      {number, lookup_pattern(patterns, number)}
    end
  end

  #   0:      1:      2:      3:      4:
  #  aaaa    ....    aaaa    aaaa    ....
  # b    c  .    c  .    c  .    c  b    c
  # b    c  .    c  .    c  .    c  b    c
  #  ....    ....    dddd    dddd    dddd
  # e    f  .    f  e    .  .    f  .    f
  # e    f  .    f  e    .  .    f  .    f
  #  gggg    ....    gggg    gggg    ....
  #
  #   5:      6:      7:      8:      9:
  #  aaaa    aaaa    aaaa    aaaa    aaaa
  # b    .  b    .  .    c  b    c  b    c
  # b    .  b    .  .    c  b    c  b    c
  #  dddd    dddd    ....    dddd    dddd
  # .    f  e    f  .    f  e    f  .    f
  # .    f  e    f  .    f  e    f  .    f
  #  gggg    gggg    ....    gggg    gggg

  # Only #1 contains exactly 2 segments
  def lookup_pattern(patterns, 1), do: Enum.find(patterns, &pattern_with(&1, 2))

  # Only #4 contains exactly 4 segments
  def lookup_pattern(patterns, 4), do: Enum.find(patterns, &pattern_with(&1, 4))

  # Only #7 contains exactly 3 segments
  def lookup_pattern(patterns, 7), do: Enum.find(patterns, &pattern_with(&1, 3))

  # Only #8 contains exactly 7 segments
  def lookup_pattern(patterns, 8), do: Enum.find(patterns, &pattern_with(&1, 7))

  # Only #2 is missing a certain segment (lower right)
  def lookup_pattern(patterns, 2) do
    {_missing_letter, [pattern_2]} =
      for char <- @all_characters, into: %{} do
        {char, patterns |> Enum.reject(fn pattern -> MapSet.member?(pattern, char) end)}
      end
      |> Enum.find(fn {_missing_letter, patterns} -> length(patterns) == 1 end)

    pattern_2
  end

  # Numbers with 5 segments is (#2, #3, #5)
  # #1 is already known
  # For (#2, #3, #5), size of intersection with #1 is 2 for #3 only
  def lookup_pattern(patterns, 3) do
    pattern_1 = lookup_pattern(patterns, 1)
    two_three_and_five = Enum.filter(patterns, &pattern_with(&1, 5))

    Enum.find(two_three_and_five, fn two_three_or_five ->
      MapSet.size(MapSet.intersection(pattern_1, two_three_or_five)) == 2
    end)
  end

  # Numbers with 6 segments is (#0, #6, #9)
  # #1 is already known
  # For (#0, #6, #9), size of intersection with #1 is 1 for #6 only
  def lookup_pattern(patterns, 6) do
    pattern_1 = lookup_pattern(patterns, 1)

    nine_six_and_zero = Enum.filter(patterns, &pattern_with(&1, 6))

    Enum.find(nine_six_and_zero, fn nine_six_or_zero ->
      MapSet.size(MapSet.intersection(pattern_1, nine_six_or_zero)) == 1
    end)
  end

  # Numbers with 5 segments is (#2, #3, #5)
  # #2 is already known
  # #3 is already known
  # The only one left is #5
  def lookup_pattern(patterns, 5) do
    two_and_three = MapSet.new([lookup_pattern(patterns, 2), lookup_pattern(patterns, 3)])
    two_three_and_five = MapSet.new(Enum.filter(patterns, &pattern_with(&1, 5)))

    MapSet.difference(two_three_and_five, two_and_three) |> MapSet.to_list() |> List.first()
  end

  # Number with 6 segments is (#0, #6, #9)
  # 6 is already known (can be excluded)
  # 4 is already known
  # Intersection of #9 and #4 -> #4, but not for #0
  def lookup_pattern(patterns, 0) do
    pattern_4 = lookup_pattern(patterns, 4)
    pattern_6 = lookup_pattern(patterns, 6)
    nine_six_zero = Enum.filter(patterns, &pattern_with(&1, 6))

    zero_and_nine =
      nine_six_zero
      |> Enum.filter(fn pattern -> !MapSet.equal?(pattern, pattern_6) end)

    zero_and_nine
    |> Enum.find(fn pattern ->
      !MapSet.equal?(MapSet.intersection(pattern_4, pattern), pattern_4)
    end)
  end

  # Number with 6 segments is (#0, #6, #9)
  # #6 is already known (can be excluded)
  # #4 is already known
  # Intersection of #9 and #4 -> 4, but not for #0
  def lookup_pattern(patterns, 9) do
    pattern_4 = lookup_pattern(patterns, 4)
    pattern_6 = lookup_pattern(patterns, 6)
    nine_six_zero = Enum.filter(patterns, &pattern_with(&1, 6))

    zero_or_nine =
      nine_six_zero
      |> Enum.filter(fn pattern -> !MapSet.equal?(pattern, pattern_6) end)

    zero_or_nine
    |> Enum.find(fn pattern ->
      MapSet.equal?(MapSet.intersection(pattern_4, pattern), pattern_4)
    end)
  end

  def pattern_with(pattern, number_of_segments) do
    MapSet.size(pattern) == number_of_segments
  end
end
