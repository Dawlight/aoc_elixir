defmodule AdventOfCode.Year2021.Day02.Submarine do
  def parse_command(command) do
    [instruction, magnitude] = String.split(command)
    {instruction, elem(Integer.parse(magnitude), 0)}
  end
end
