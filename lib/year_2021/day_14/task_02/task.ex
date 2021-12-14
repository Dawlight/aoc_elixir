defmodule AdventOfCode.Year2021.Day14.Task02 do
  alias AdventOfCode.Year2021.Day14.{
    Submarine
  }

  def solve(input) do
    {start, rules} = Submarine.parse_input(input)

    char_frequencies = start |> Enum.frequencies()
    frequencies = to_pair_frequencies(start, rules, %{})

    {_, char_frequencies} =
      for _ <- 1..40, reduce: {frequencies, char_frequencies} do
        {frequencies, char_frequencies} ->
          {frequencies, char_frequencies} = polymerize(frequencies, char_frequencies, rules)
          {frequencies, char_frequencies}
      end

    {_, min} = char_frequencies |> Enum.min_by(fn {_, freq} -> freq end)
    {_, max} = char_frequencies |> Enum.max_by(fn {_, freq} -> freq end)

    max - min
  end

  def to_pair_frequencies([_], _rules, freq), do: freq

  def to_pair_frequencies([a, b | polymer], rules, freq) do
    case rules[a <> b] do
      nil ->
        to_pair_frequencies([b | polymer], rules, freq)

      _ ->
        freq = freq |> Map.update(a <> b, 1, fn number_of -> number_of + 1 end)
        to_pair_frequencies([b | polymer], rules, freq)
    end
  end

  defp polymerize(frequencies, char_frequencies, rules) do
    for {combo, combo_freq} <- frequencies, reduce: {%{}, char_frequencies} do
      {frequencies, char_frequencies} ->
        case rules[combo] do
          nil ->
            {frequencies, char_frequencies}

          insert ->
            [a, b] = String.graphemes(combo)

            frequencies =
              frequencies
              |> Map.update(a <> insert, combo_freq, fn n -> n + combo_freq end)
              |> Map.update(insert <> b, combo_freq, fn n -> n + combo_freq end)

            char_frequencies =
              char_frequencies
              |> Map.update(insert, combo_freq, fn n -> n + combo_freq end)

            {frequencies, char_frequencies}
        end
    end
  end
end
