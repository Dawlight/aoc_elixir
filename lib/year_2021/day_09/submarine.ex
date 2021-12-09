defmodule AdventOfCode.Year2021.Day09.Submarine do
  def parse_input(input) do
    rows =
      input
      |> String.split("\n")
      |> Enum.map(fn row ->
        row
        |> String.graphemes()
        |> Enum.map(fn grapheme -> String.to_integer(grapheme) end)
      end)

    for {row, y} <- Enum.with_index(rows),
        {number, x} <- Enum.with_index(row),
        into: %{},
        do: {{x, y}, number}
  end

  def get_low_points(matrix) do
    {max_x, max_y} = get_max_coords(matrix)

    matrix
    |> Enum.filter(fn {_, height} = point ->
      get_neighbours(matrix, point, max_x, max_y)
      |> Enum.to_list()
      |> Map.new()
      |> Map.values()
      |> Enum.all?(fn neighbour_height -> neighbour_height > height end)
    end)
    |> Map.new()
  end

  def get_max_coords(matrix) do
    {{max_x, _}, _} =
      matrix
      |> Enum.max_by(fn {{x1, _y}, _} -> x1 end, fn -> nil end)

    {{_, max_y}, _} =
      matrix
      |> Enum.max_by(fn {{_, y1}, _} -> y1 end, fn -> nil end)

    {max_x, max_y}
  end

  def get_neighbours(matrix, {{x, y}, _height}, max_x, max_y) do
    cardinal_coords = [{x, y + 1}, {x + 1, y}, {x, y - 1}, {x - 1, y}]

    valid_coords =
      Enum.filter(cardinal_coords, fn {x, y} ->
        x >= 0 and y >= 0 and
          x <= max_x and y <= max_y
      end)

    neighbours = for coord <- valid_coords, do: {coord, Map.get(matrix, coord, nil)}

    MapSet.new(neighbours)
  end

  def get_basins(matrix) do
    starting_points = get_low_points(matrix)

    for point <- starting_points,
        do: traverse_basin(matrix, point)
  end

  defp traverse_basin(matrix, starting_point) do
    {max_x, max_y} = get_max_coords(matrix)

    Enum.reduce_while(
      Stream.cycle(1..1),
      %{visited: [starting_point], stack: [starting_point]},
      fn _number, acc ->
        %{visited: visited, stack: stack} = acc

        [current_point | stack] = stack

        neighbours = get_unvisited_neighbours(matrix, current_point, visited, max_x, max_y)

        stack =
          for neighbour <- neighbours, reduce: stack do
            stack -> [neighbour | stack]
          end

        visited = visited ++ MapSet.to_list(neighbours)

        case stack do
          [] -> {:halt, visited}
          _ -> {:cont, %{visited: visited, stack: stack}}
        end
      end
    )
  end

  defp get_unvisited_neighbours(matrix, point, visited, max_x, max_y) do
    get_neighbours(matrix, point, max_x, max_y)
    |> MapSet.to_list()
    |> Enum.filter(fn neighbour -> is_valid_neighbour(point, neighbour, visited) end)
    |> MapSet.new()
  end

  defp is_valid_neighbour(point, neighbour, visited) do
    {_, height} = point
    {_, neighbour_height} = neighbour

    neighbour_height >= height &&
      neighbour_height != 9 &&
      !Enum.member?(visited, neighbour)
  end
end
