defmodule AdventOfCode.Year2021.Day03.Task01 do
  # TODO: BIG REFACTOR
  # TODO: BIG REFACTOR
  # TODO: BIG REFACTOR

  def solve(input) do
    lines =
      input
      |> Enum.map(fn line -> String.trim(line) |> String.graphemes() end)

    bit_counts =
      for line <- lines, reduce: %{} do
        bits ->
          for {bit, index} <- Enum.with_index(line), reduce: bits do
            bits ->
              bit_count = bits[index] || %{"0" => 0, "1" => 0}

              bit_count = %{bit_count | bit => bit_count[bit] + 1}

              bits |> Map.put(index, bit_count)
          end
      end

    {gamma, epsilon} =
      for {_index, %{"0" => zeroes, "1" => ones}} <- bit_counts, reduce: {"", ""} do
        {gamma, epsilon} ->
          gamma =
            case ones > zeroes do
              true -> gamma <> "0"
              false -> gamma <> "1"
            end

          epsilon =
            case ones < zeroes do
              true -> epsilon <> "0"
              false -> epsilon <> "1"
            end

          {gamma, epsilon}
      end

    {gamma, _} = Integer.parse(gamma, 2)
    {epsilon, _} = Integer.parse(epsilon, 2)

    gamma * epsilon
  end
end
