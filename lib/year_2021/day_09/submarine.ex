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
    matrix
    |> Enum.filter(fn {coords, height} ->
      get_neighbours(matrix, coords, [])
      |> Map.values()
      |> Enum.all?(fn neighbour_height -> neighbour_height > height end)
    end)
    |> Map.new()
  end

  def get_neighbours(matrix, {x, y}, exclude) do
    {{max_x, _}, _} =
      matrix
      |> Enum.max_by(fn {{x1, _y}, _} -> x1 end, fn -> nil end)

    {{_, max_y}, _} =
      matrix
      |> Enum.max_by(fn {{_, y1}, _} -> y1 end, fn -> nil end)

    north = {x, y + 1}
    east = {x + 1, y}
    south = {x, y - 1}
    west = {x - 1, y}

    directions =
      [north, east, south, west]
      |> Enum.filter(fn direction -> !Enum.member?(exclude, direction) end)

    for direction <- directions, reduce: %{} do
      neighbour_coords ->
        case direction do
          {x, y} when x < 0 or y < 0 or x > max_x or y > max_y ->
            neighbour_coords

          coord ->
            Map.put(neighbour_coords, coord, Map.get(matrix, coord, nil))
        end
    end
  end

  def get_basins(matrix) do
    starting_points = get_low_points(matrix) |> Map.keys()

    Enum.map(starting_points, fn coord -> traverse_basin(matrix, coord, [coord], 0) end)
    |> Enum.map(fn thing -> thing |> Enum.map(fn thing2 -> matrix[thing2] end) end)
  end

  # defp traverse_basin(_, _, _, 2), do: []

  defp traverse_basin(matrix, coord, visited_coords, depth) do
    neighbours =
      get_neighbours(matrix, coord, visited_coords)
      |> Map.keys()
      |> Enum.filter(fn n_coord -> matrix[n_coord] >= matrix[coord] && matrix[n_coord] != 9 end)

    acc =
      for neighbour <- neighbours, reduce: [] do
        acc ->
          acc ++ traverse_basin(matrix, neighbour, [coord | visited_coords], depth + 1)
      end

    Enum.uniq([coord] ++ acc ++ neighbours)
  end
end
