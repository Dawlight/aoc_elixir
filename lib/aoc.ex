defmodule AdventOfCode do
  def solve_task(year, day, task) do
    task_parameters = pad_task_parameters(year, day, task)
    task_input = (get_task_path(task_parameters) <> "/input") |> File.read!()
    task_module = get_task_module(task_parameters)

    case Code.ensure_compiled(task_module) do
      {:module, module} ->
        result = apply(module, :solve, [task_input])
        {:ok, result}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_task_path({year, day, task}) do
    "lib/year_#{year}/day_#{day}/task_#{task}"
  end

  defp get_task_module({year, day, task}) do
    String.to_atom("Elixir.AdventOfCode.Year#{year}.Day#{day}.Task#{task}")
  end

  defp pad_task_parameters(year, day, task) do
    year = year |> Integer.to_string()

    day = day |> Integer.to_string() |> String.pad_leading(2, "0")
    task = task |> Integer.to_string() |> String.pad_leading(2, "0")

    {year, day, task}
  end
end
