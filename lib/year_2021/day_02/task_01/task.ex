defmodule AdventOfCode.Year2021.Day02.Task01 do
  alias AdventOfCode.Year2021.Day02.Submarine

  @initial_vector %{horizontal: 0, depth: 0}

  def solve(input) do
    %{horizontal: horizontal, depth: depth} =
      input
      |> Enum.map(&Submarine.parse_command/1)
      |> Enum.reduce(@initial_vector, &execute_command/2)

    horizontal * depth
  end

  defp execute_command({"forward", magnitude}, vector) do
    %{vector | horizontal: vector.horizontal + magnitude}
  end

  defp execute_command({"down", magnitude}, vector) do
    %{vector | depth: vector.depth + magnitude}
  end

  defp execute_command({"up", magnitude}, vector) do
    %{vector | depth: vector.depth - magnitude}
  end
end
