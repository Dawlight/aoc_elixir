defmodule AdventOfCode.Year2021.Day11.Submarine do
  @max 9

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

  def simulate(octopi, steps) do
    simulate_step(octopi, 1, steps, 0)
  end

  defp simulate_step(octopi, step, steps, flashes) when step == steps, do: {octopi, step, flashes}

  defp simulate_step(octopi, step, steps, flashes) do
    IO.puts("Step #{step}")

    octopi = increment_all(octopi)

    {octopi, new_flashes} = propagate_flash(octopi, MapSet.new([]))

    octopi =
      octopi
      |> reset_energy_overload()

    case Enum.all?(octopi, fn {_, energy} -> energy == 0 end) do
      true ->
        {octopi, step, flashes}

      false ->
        octopi |> simulate_step(step + 1, steps, flashes + new_flashes)
    end

    # IO.getn("Continue?")
  end

  defp increment_all(octopi) do
    for {coord, energy} <- octopi, into: %{}, do: {coord, energy + 1}
  end

  defp propagate_flash(octopi, flashed_octopi) do
    IO.puts("PROPAGATE FLASH")

    {flashed_octopi, neighbours} =
      for {coords, energy} = octopus <- octopi, reduce: {flashed_octopi, []} do
        {flashed_octopi, neighbours} ->
          case MapSet.member?(flashed_octopi, coords) == false && energy > 9 do
            false ->
              {flashed_octopi, neighbours}

            true ->
              {MapSet.put(flashed_octopi, coords), neighbours ++ get_neighbours(octopi, octopus)}
          end
      end

    case neighbours do
      [] ->
        {octopi, MapSet.size(flashed_octopi)}

      _ ->
        octopi =
          for {coord, _} <- neighbours, reduce: octopi do
            octopi -> Map.update!(octopi, coord, fn energy -> energy + 1 end)
          end

        print_matrix(octopi)
        propagate_flash(octopi, flashed_octopi)
    end
  end

  defp reset_energy_overload(octopi) do
    IO.puts("RESET ENERGY")

    for {coords, energy} <- octopi, reduce: octopi do
      octopi ->
        case energy > 9 do
          true -> Map.put(octopi, coords, 0)
          false -> octopi
        end
    end
  end

  def print_matrix(octopi) do
    for y <- 0..@max do
      for x <- 0..@max, reduce: "" do
        string ->
          string <>
            (Map.get(octopi, {x, y})
             |> Integer.to_string()
             |> String.pad_leading(3)
             |> String.pad_trailing(3))
      end
      |> IO.puts()
    end

    IO.puts(".")

    octopi
  end

  @spec get_neighbours(any, {{number, number}, any}) :: list
  def get_neighbours(octopi, {{x, y}, _energy}) do
    x_max = @max
    y_max = @max

    n = {x, y + 1}
    ne = {x + 1, y + 1}
    e = {x + 1, y}
    se = {x + 1, y - 1}
    s = {x, y - 1}
    sw = {x - 1, y - 1}
    w = {x - 1, y}
    nw = {x - 1, y + 1}
    neighbour_coords = [n, ne, e, se, s, sw, w, nw]

    valid_coords =
      Enum.filter(neighbour_coords, fn {x, y} ->
        x >= 0 and y >= 0 and x <= x_max and y <= y_max
      end)

    Enum.filter(octopi, fn {octo_coord, _} -> Enum.member?(valid_coords, octo_coord) end)
    |> IO.inspect(label: "NEIGHBOURS of #{x}, #{y}")
  end
end
