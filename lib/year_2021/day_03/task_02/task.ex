defmodule AdventOfCode.Year2021.Day03.Task02 do
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

    {oxygen, _} =
      for {bit_index, _} <- bit_counts, reduce: lines do
        remaining_lines ->
          bit_counts = get_bit_counts(remaining_lines)
          count = bit_counts[bit_index]

          case length(remaining_lines) do
            1 ->
              remaining_lines

            _ ->
              keep_bit =
                cond do
                  count["0"] == count["1"] -> "1"
                  count["0"] > count["1"] -> "0"
                  count["0"] < count["1"] -> "1"
                end

              remaining_lines
              |> Enum.filter(fn line -> line |> Enum.at(bit_index, nil) != keep_bit end)
          end
      end
      |> Enum.join()
      |> Integer.parse(2)

    {co2, _} =
      for {bit_index, _} <- bit_counts, reduce: lines do
        remaining_lines ->
          bit_counts = get_bit_counts(remaining_lines)
          count = bit_counts[bit_index]

          case length(remaining_lines) do
            1 ->
              remaining_lines

            _ ->
              keep_bit =
                cond do
                  count["0"] == count["1"] -> "0"
                  count["0"] < count["1"] -> "0"
                  count["0"] > count["1"] -> "1"
                end

              remaining_lines
              |> Enum.filter(fn line -> line |> Enum.at(bit_index, nil) != keep_bit end)
          end
      end
      |> Enum.join()
      |> Integer.parse(2)

    co2 * oxygen
  end

  defp get_bit_counts(lines) do
    for line <- lines, reduce: %{} do
      bits ->
        for {bit, index} <- Enum.with_index(line), reduce: bits do
          bits ->
            bit_count = bits[index] || %{"0" => 0, "1" => 0}

            bit_count = %{bit_count | bit => bit_count[bit] + 1}

            bits |> Map.put(index, bit_count)
        end
    end
  end
end
