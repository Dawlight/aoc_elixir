defmodule AdventOfCode.Year2021.Day01.Submarine do
  def get_measurement_increases(measurements, window_size) do
    measurements
    |> Enum.chunk_every(window_size, 1, [0])
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, [0])
    |> Enum.count(fn [previous | [current]] -> current > previous end)
  end
end
