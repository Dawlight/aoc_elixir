defmodule AdventOfCode.Year2021.Day02.Task02 do
  alias AdventOfCode.Year2021.Day02.Submarine

  @initial_vector %{horizontal: 0, depth: 0, aim: 0}

  def solve(input) do
    %{horizontal: horizontal, depth: depth} =
      input
      |> Enum.map(&Submarine.parse_command/1)
      |> Enum.reduce(@initial_vector, &execute_command/2)

    horizontal * depth
  end

  defp execute_command({"forward", magnitude}, vector) do
    %{horizontal: horizontal, depth: depth, aim: aim} = vector
    %{vector | horizontal: horizontal + magnitude, depth: depth + aim * magnitude}
  end

  defp execute_command({"down", magnitude}, vector) do
    %{vector | aim: vector.aim + magnitude}
  end

  defp execute_command({"up", magnitude}, vector) do
    %{vector | aim: vector.aim - magnitude}
  end
end
