defmodule AdventOfCode.Year2021.Day03.Submarine do
  def get_bit_counts(values) do
    for bits <- values, reduce: %{} do
      bit_counts ->
        for {bit, bit_position} <- Enum.with_index(bits), reduce: bit_counts do
          bit_counts ->
            bit_count = bit_counts[bit_position] || %{"0" => 0, "1" => 0}
            bit_count = %{bit_count | bit => bit_count[bit] + 1}
            bit_counts |> Map.put(bit_position, bit_count)
        end
    end
  end

  def to_bit_string(line) do
    line
    |> String.trim()
    |> String.graphemes()
  end
end
