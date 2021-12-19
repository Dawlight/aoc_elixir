defmodule AdventOfCode.Year2021.Day15.Task01 do
  alias AdventOfCode.Year2021.Day15.{
    Submarine
  }

  def solve(input) do
    matrix = Submarine.parse_input(input)

    x_max = Enum.map(matrix, fn {{x, _y}, _risk} -> x end) |> Enum.max()
    y_max = Enum.map(matrix, fn {{_x, y}, _risk} -> y end) |> Enum.max()

    {start_coord, risk} = Enum.find(matrix, fn {coords, _} -> coords == {0, 0} end)

    goal =
      Enum.find(matrix, fn {coords, _} -> coords == {x_max, y_max} end)
      |> IO.inspect(label: "GOAL")

    search(matrix, [{start_coord, risk, 0}], goal, [])
    # |> Enum.reduce(0, fn {_, risk}, acc -> acc + risk end)
  end

  defp search(_matrix, [], _goal, [first | _visited]), do: first

  defp search(matrix, queue, {goal_coord, _} = goal, visited) do
    [current | queue] = queue |> IO.inspect(label: "QUEUE")

    case current do
      {^goal_coord, 0, total} ->
        total

      _ ->
        visited =
          case current do
            {coords, 0, _} -> [coords | visited]
            _ -> visited
          end

        IO.getn("Continue? ")

        neighbours =
          get_neighbours(matrix, current)
          |> Enum.filter(fn {coord, _} -> !Enum.member?(visited, coord) end)
          |> IO.inspect(label: "")

        queue = queue ++ neighbours

        search(matrix, queue, goal, visited)
    end
  end

  # @spec search(any, any, any, any) :: any
  # def search(_weights, distances, _goal, visited) when distances == %{},
  #   do: visited

  # def search(_weights, [], _goal, visited),
  #   do: visited

  # def search(_weights, _distances, goal, [goal | visited]),
  #   do: [goal | visited]

  # def search(weights, distances, {goal_coord, _} = goal, visited) do
  #   {min_dist_coord, min_dist} = current = Enum.min_by(distances, fn {_, cost} -> cost end)
  #   {_, distances} = Map.pop!(distances, min_dist_coord)

  #   case current do
  #     {^goal_coord, _} ->
  #       min_dist

  #     {_, :infinity} ->
  #       [first | _visited] = visited
  #       first

  #     _ ->
  #       neighbour_coords =
  #         get_neighbours(weights, min_dist_coord)
  #         |> Enum.reject(fn {coord, _} -> distances[coord] == nil end)
  #         |> Enum.map(fn {coord, _} -> coord end)

  #       distances =
  #         for coord <- neighbour_coords, reduce: distances do
  #           distances ->
  #             case distances[coord] > min_dist + weights[coord] do
  #               true -> %{distances | coord => min_dist + weights[coord]}
  #               false -> distances
  #             end
  #         end

  #       search(weights, distances, goal, [current | visited])
  #   end
  # end

  defp inspect_matrix(matrix) when matrix == %{}, do: :lol

  defp inspect_matrix(matrix) do
    x_max =
      Enum.map(matrix, fn {{x, _y}, _risk} -> x end)
      |> Enum.max()

    y_max =
      Enum.map(matrix, fn {{_x, y}, _risk} -> y end)
      |> Enum.max()

    for y <- 0..y_max do
      string =
        for x <- 0..x_max, reduce: "" do
          string ->
            case matrix[{x, y}] do
              nil ->
                string <> "*  "

              distance ->
                case distance do
                  1_000_000 -> string <> "x  "
                  distance -> string <> String.pad_trailing("#{distance}", 3)
                end
            end
        end

      IO.puts(string)
    end

    IO.puts("End")
    matrix
  end

  def get_neighbours(matrix, {{x, y}, 0, risk}) do
    x_max =
      Enum.map(matrix, fn {{x, _y}, _} -> x end)
      |> Enum.max()

    y_max =
      Enum.map(matrix, fn {{_x, y}, _} -> y end)
      |> Enum.max()

    n = {x, y + 1}
    e = {x + 1, y}
    s = {x, y - 1}
    w = {x - 1, y}
    neighbour_coords = [n, e, s, w]

    valid_coords =
      Enum.filter(neighbour_coords, fn {x, y} ->
        x >= 0 and y >= 0 and x <= x_max and y <= y_max
      end)

    Enum.filter(matrix, fn {octo_coord, _} -> Enum.member?(valid_coords, octo_coord) end)
    |> Enum.map(fn {coord, start_risk} -> {coord, start_risk, start_risk + risk} end)
  end

  def get_neighbours(_matrix, {coord, risk,}), do: [{coord, risk - 1}]
end
