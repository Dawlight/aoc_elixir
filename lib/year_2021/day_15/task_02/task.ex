defmodule AdventOfCode.Year2021.Day15.Task02 do
  alias AdventOfCode.Year2021.Day15.{
    Submarine
  }

  @repeats 5

  @max 499

  def solve(input) do
    matrix = Submarine.parse_input(input) |> IO.inspect(label: "INITIAL")

    x_max =
      ((Enum.map(matrix, fn {{x, _y}, _risk} -> x end) |> Enum.max()) + 1)
      |> IO.inspect(label: "X_MAX")

    y_max =
      ((Enum.map(matrix, fn {{_x, y}, _risk} -> y end) |> Enum.max()) + 1)
      |> IO.inspect(label: "Y_MAX")

    matrix =
      for y_l <- 0..4, x_l <- 0..4, reduce: %{} do
        map ->
          map1 =
            for {{x, y}, risk} <- matrix, into: %{} do
              risk = rem(risk + (x_l + y_l) - 1, 9) + 1

              {{x + x_l * x_max, y + y_l * y_max}, risk}
            end

          Map.merge(map1, map)
      end
      |> inspect_matrix()

    x_max = Enum.map(matrix, fn {{x, _y}, _risk} -> x end) |> Enum.max()
    y_max = Enum.map(matrix, fn {{_x, y}, _risk} -> y end) |> Enum.max()

    {start_coord, _} = start = Enum.find(matrix, fn {coords, _} -> coords == {0, 0} end)

    {goal_coord, _} = goal = Enum.find(matrix, fn {coords, _} -> coords == {x_max, y_max} end)

    costs =
      Enum.map(matrix, fn {coord, _} = item ->
        case item do
          ^start -> {coord, 0}
          _ -> {coord, :infinity}
        end
      end)
      |> Map.new()

    scores =
      Enum.map(matrix, fn {coord, _} = item ->
        case item do
          ^start -> {coord, distance(goal_coord, start_coord)}
          _ -> {coord, :infinity}
        end
      end)
      |> Map.new()

    start_coord |> IO.inspect(label: "START COORD")

    queue =
      Heap.new(fn {_, score_1}, {_, score_2} -> score_1 < score_2 end)
      |> Heap.push({start_coord, distance(goal_coord, start_coord)})

    search(queue, matrix, costs, scores, goal_coord)
  end

  def search([], _risks, _costs, _scores, _goal), do: :LOL

  def search(queue, risks, costs, scores, goal) do
    {current, _} = Heap.root(queue)
    queue = Heap.pop(queue)

    case current do
      ^goal ->
        costs[goal]

      {_, :infinity} ->
        :lol

      _ ->
        neighbours =
          get_neighbours(risks, current)
          |> Enum.sort_by(fn neighbour -> risks[neighbour] end)

        {costs, scores, queue} =
          for neighbour <- neighbours, reduce: {costs, scores, queue} do
            {costs, scores, queue} ->
              new_cost = costs[current] + risks[neighbour]
              old_cost = costs[neighbour]

              case new_cost >= old_cost do
                true ->
                  {costs, scores, queue}

                false ->
                  costs = %{costs | neighbour => new_cost}
                  new_score = new_cost + distance(goal, neighbour)
                  scores = %{scores | neighbour => new_score}

                  case Enum.member?(queue, neighbour) do
                    true ->
                      {costs, scores, queue}

                    false ->
                      {costs, scores, Heap.push(queue, {neighbour, scores[neighbour]})}
                  end
              end
          end

        search(queue, risks, costs, scores, goal)
    end
  end

  defp distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp inspect_matrix(matrix) when matrix == %{}, do: :lol

  defp inspect_matrix(matrix) do
    x_max = @max

    y_max = @max

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

  def get_neighbours(matrix, {x, y}) do
    n = {x, y + 1}
    e = {x + 1, y}
    s = {x, y - 1}
    w = {x - 1, y}
    neighbour_coords = [n, e, s, w]

    valid_coords =
      Enum.filter(neighbour_coords, fn {x, y} ->
        x >= 0 and y >= 0 and x <= @max and y <= @max
      end)

    valid_coords
  end
end
