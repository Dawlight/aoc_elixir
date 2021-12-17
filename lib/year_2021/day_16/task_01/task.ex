defmodule AdventOfCode.Year2021.Day16.Task01 do
  alias AdventOfCode.Year2021.Day16.{
    Submarine
  }

  @operators %{
    0 => :sum,
    1 => :product,
    2 => :minimum,
    3 => :maximum,
    5 => :greater,
    6 => :less,
    7 => :equal
  }

  def solve(input) do
    transformed =
      Submarine.parse_input(input)
      |> String.trim()
      |> convert()
      |> parse()
      |> Enum.filter(fn thing -> elem(thing, 0) != :rest end)
      |> transform()

    [sum: transformed] |> calculate()
  end

  #
  # Operations by size
  #

  def transform(operations), do: transform(operations, [])

  def transform([], buffer), do: buffer

  def transform([{:literal, value, size} | operations], buffer) do
    buffer = buffer ++ [{:literal, value, size}]
    transform(operations, buffer)
  end

  def transform([{id, :size, size, _} | operations], buffer) do
    {taken, rest} = take_size(operations, size)
    buffer = buffer ++ [{id, transform(taken)}]
    transform(rest, buffer)
  end

  def transform([{id, :number, number, _} | operations], buffer) do
    {taken, rest} = take_number(operations, number)
    buffer = buffer ++ [{id, transform(taken)}]
    transform(rest, buffer)
  end

  def take_number(operations, number), do: take_number(operations, number, [])

  def take_number(operations, 0, buffer), do: {buffer, operations}

  def take_number([], _, buffer), do: {buffer, []}

  def take_number([operation | operations], number, buffer) do
    # operation |> IO.inspect(label: "OPERATION")
    buffer = buffer ++ [operation]

    {taken, rest} =
      case operation do
        {_, :number, number, _} -> take_number(operations, number)
        {_, :size, size, _} -> take_size(operations, size)
        {_, _, _} = _literal -> {[], operations}
      end

    # taken |> IO.inspect(label: "TAKEN")
    # buffer |> IO.inspect(label: "BUFFER")

    buffer = buffer ++ taken

    take_number(rest, number - 1, buffer)
  end

  def take_size(operations, size), do: take_size(operations, size, [])

  def take_size(operations, size, buffer) when size <= 0,
    do: {buffer |> Enum.reverse(), operations}

  def take_size([], _size, buffer), do: {buffer |> Enum.reverse(), []}

  def take_size([operation | operations], size, buffer) do
    # buffer |> IO.inspect(label: "SIZE BUFFER")
    operation_size = operation_size(operation)
    take_size(operations, size - operation_size, [operation | buffer])
  end

  defp operation_size(operation) do
    t_size = tuple_size(operation)
    elem(operation, t_size - 1)
  end

  def parse(binary), do: parse_packet(binary, 0, [])

  def parse_packet(<<>>, _psize, buffer), do: buffer |> Enum.reverse()

  def parse_packet(<<_::binary-size(3)>> <> rest, 0, buffer) do
    parse_packet(rest, 3, buffer)
  end

  def parse_packet(<<head::binary-size(3)>> <> rest, 3, buffer) do
    type_id = String.to_integer(head, 2)
    parse_packet(rest, 3 + 3, [{:type_id, type_id} | buffer])
  end

  def parse_packet(bin, psize, [{:type_id, 4} | buffer]) do
    parse_literal(bin, psize, buffer)
  end

  def parse_packet(bin, psize, [{:type_id, operator_type} | buffer]) do
    parse_operator(bin, psize, buffer, operator_type)
  end

  def parse_packet("0" <> rest, psize, buffer),
    do: parse_packet(rest, psize, [{:rest, psize} | buffer])

  def parse_packet(_bin, _psize, buffer), do: buffer |> Enum.reverse()

  def parse_operator("0" <> rest, 6, buffer, operator_type) do
    case String.length(rest) >= 15 do
      true ->
        psize = 1 + 6 + 15
        <<sub_packets_length::binary-size(15)>> <> rest = rest

        sub_packets_length = String.to_integer(sub_packets_length, 2)
        buffer = [{@operators[operator_type], :size, sub_packets_length, psize} | buffer]

        parse_packet(rest, 0, buffer)

      false ->
        parse_packet(rest, 0, buffer)
    end
  end

  def parse_operator("1" <> rest, 6, buffer, operator_type) do
    case String.length(rest) >= 1 do
      true ->
        psize = 1 + 6 + 12
        <<sub_packets::binary-size(11)>> <> rest = rest
        sub_packets = String.to_integer(sub_packets, 2)

        buffer = [{@operators[operator_type], :number, sub_packets, psize} | buffer]
        parse_packet(rest, 0, buffer)

      false ->
        parse_packet(rest, 0, buffer)
    end
  end

  def parse_literal(bin, psize, buffer), do: parse_literal(bin, psize, [], buffer)

  def parse_literal(<<head::binary-size(5)>> <> rest, psize, number_buffer, buffer) do
    # head |> IO.inspect(label: "HEAD #{psize}")

    case head do
      "1" <> number ->
        parse_literal(rest, psize + 5, [number | number_buffer], buffer)

      "0" <> number ->
        actual_number =
          [number | number_buffer]
          |> Enum.reverse()
          |> Enum.join()
          |> String.to_integer(2)

        parse_packet(rest, 0, [{:literal, actual_number, psize + 5} | buffer])
    end
  end

  def convert(hex), do: convert(hex, [])
  def convert(<<>>, buffer), do: Enum.reverse(buffer) |> Enum.join()
  def convert("0" <> rest, buffer), do: convert(rest, ["0000" | buffer])
  def convert("1" <> rest, buffer), do: convert(rest, ["0001" | buffer])
  def convert("2" <> rest, buffer), do: convert(rest, ["0010" | buffer])
  def convert("3" <> rest, buffer), do: convert(rest, ["0011" | buffer])
  def convert("4" <> rest, buffer), do: convert(rest, ["0100" | buffer])
  def convert("5" <> rest, buffer), do: convert(rest, ["0101" | buffer])
  def convert("6" <> rest, buffer), do: convert(rest, ["0110" | buffer])
  def convert("7" <> rest, buffer), do: convert(rest, ["0111" | buffer])
  def convert("8" <> rest, buffer), do: convert(rest, ["1000" | buffer])
  def convert("9" <> rest, buffer), do: convert(rest, ["1001" | buffer])
  def convert("A" <> rest, buffer), do: convert(rest, ["1010" | buffer])
  def convert("B" <> rest, buffer), do: convert(rest, ["1011" | buffer])
  def convert("C" <> rest, buffer), do: convert(rest, ["1100" | buffer])
  def convert("D" <> rest, buffer), do: convert(rest, ["1101" | buffer])
  def convert("E" <> rest, buffer), do: convert(rest, ["1110" | buffer])
  def convert("F" <> rest, buffer), do: convert(rest, ["1111" | buffer])

  def calculate([{:sum, values}]) do
    for value <- values, reduce: 0 do
      sum ->
        sum + calculate([value])
    end
  end

  def calculate([{:product, values}]) do
    for value <- values, reduce: 1 do
      sum ->
        sum * calculate([value])
    end
  end

  def calculate([{:minimum, values}]) do
    values |> Enum.map(fn value -> calculate([value]) end) |> Enum.min()
  end

  def calculate([{:maximum, values}]) do
    values |> Enum.map(fn value -> calculate([value]) end) |> Enum.max()
  end

  def calculate([{:greater, values}]) do
    [first, second | _rest] = values
    first = calculate([first])
    second = calculate([second])

    if first > second, do: 1, else: 0
  end

  def calculate([{:less, values}]) do
    [first, second | _rest] = values
    first = calculate([first])
    second = calculate([second])

    if first < second, do: 1, else: 0
  end

  def calculate([{:equal, values}]) do
    [first, second | _rest] = values
    first = calculate([first])
    second = calculate([second])

    if first == second, do: 1, else: 0
  end

  def calculate([{:literal, value, _}]), do: value

  def calculate(lol) do
    lol |> IO.inspect(label: "GRAPH")
    lol |> Enum.count() |> IO.inspect(label: "COUNT")
  end
end
