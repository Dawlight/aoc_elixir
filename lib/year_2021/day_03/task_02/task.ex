defmodule AdventOfCode.Year2021.Day03.Task02 do
  alias AdventOfCode.Year2021.Day03.Submarine

  def solve(input) do
    values = input |> Enum.map(&Submarine.to_bit_string/1)

    {oxygen, _} =
      filter_by_bits(values, :oxygen)
      |> Enum.join()
      |> Integer.parse(2)

    {co2, _} =
      filter_by_bits(values, :co2)
      |> Enum.join()
      |> Integer.parse(2)

    co2 * oxygen
  end

  def filter_by_bits(values, parameter) do
    value_length =
      values
      |> List.first()
      |> Enum.count()

    for bit_index <- 0..(value_length - 1), reduce: values do
      remaining_values ->
        bit_counts = Submarine.get_bit_counts(remaining_values)
        bit_count = bit_counts[bit_index]

        case remaining_values do
          [correct_value] ->
            [correct_value]

          _ ->
            keep_bit = bit_filter(bit_count, parameter)

            remaining_values |> Enum.filter(&(Enum.at(&1, bit_index) != keep_bit))
        end
    end
  end

  def bit_filter(%{"0" => zeroes, "1" => ones}, :oxygen) do
    cond do
      zeroes == ones -> "1"
      zeroes > ones -> "0"
      zeroes < ones -> "1"
    end
  end

  def bit_filter(%{"0" => zeroes, "1" => ones}, :co2) do
    cond do
      zeroes == ones -> "0"
      zeroes < ones -> "0"
      zeroes > ones -> "1"
    end
  end
end
