defmodule AdventOfCode.CLI do
  def main(args) do
    case args do
      [year, day, task] ->
        {year, _} = Integer.parse(year)
        {day, _} = Integer.parse(day)
        {task, _} = Integer.parse(task)

        case apply(AdventOfCode, :solve_task, [year, day, task]) do
          {:error, reason} ->
            IO.puts(
              "A solution for task #{task} of day #{day} in #{year} could not be found \n (#{reason})"
            )

          {:ok, result} ->
            IO.puts("The solution for the given task is, supposedly, this:\n #{result}")
        end

      _ ->
        IO.puts("You typed wrong. Type like this:\n year day task")
    end
  end
end
