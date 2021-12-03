defmodule AdventOfCode.Year2021.Day03.Task01 do
  alias AdventOfCode.Year2021.Day03.Submarine

  def solve(input) do
    values = input |> Enum.map(&Submarine.to_bit_string/1)

    bit_counts = Submarine.get_bit_counts(values)

    {gamma, epsilon} =
      for {_index, bit_count} <- bit_counts, reduce: {"", ""} do
        {gamma, epsilon} ->
          gamma = gamma <> get_bit(bit_count, :gamma)
          epsilon = epsilon <> get_bit(bit_count, :epsilon)

          {gamma, epsilon}
      end

    {gamma, _} = Integer.parse(gamma, 2)
    {epsilon, _} = Integer.parse(epsilon, 2)

    gamma * epsilon
  end

  def get_bit(%{"0" => zeroes, "1" => ones}, :gamma) do
    case ones > zeroes do
      true -> "0"
      false -> "1"
    end
  end

  def get_bit(%{"0" => zeroes, "1" => ones}, :epsilon) do
    case zeroes > ones do
      true -> "0"
      false -> "1"
    end
  end
end
