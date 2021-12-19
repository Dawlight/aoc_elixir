defmodule AdventOfCode.Year2021.Day17.Task01 do
  alias AdventOfCode.Year2021.Day17.{
    Submarine
  }

  @area_x 111..161
  @area_y -154..-101

  def solve(_input) do
    for x <- 0..(@area_x.last + 1), y <- @area_y.first..200 do
      {{x, y}, step({{0, 0}, {x, y}})}
    end
    |> Enum.reject(fn {_, path} -> path == :miss end)
    |> Enum.map(fn {_, path} ->
      path |> Enum.map(fn {{_x, y}, _} -> y end) |> Enum.max()
    end)
    |> Enum.max()
  end

  def step(start_vectors), do: step(start_vectors, [])

  def step({{p_x, p_y}, {v_x, v_y}}, path) do
    p_x = p_x + v_x
    p_y = p_y + v_y

    v_x = if v_x > 0, do: v_x - 1, else: if(v_x < 0, do: v_x + 1, else: 0)
    v_y = v_y - 1

    new_vectors = {{p_x, p_y}, {v_x, v_y}}

    hit? = Enum.member?(@area_x, p_x) and Enum.member?(@area_y, p_y)
    miss? = p_x > @area_x.last or p_y < @area_y.first

    if hit? do
      IO.puts("HIT!")
      [new_vectors | path] |> Enum.reverse()
    else
      if miss? do
        :miss
      else
        step(new_vectors, [new_vectors | path])
      end
    end
  end
end
