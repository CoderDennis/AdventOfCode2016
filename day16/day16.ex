defmodule Day16 do
  require Integer
  
  @input "01110110101001000"

  def puzzle() do
    fill_and_checksum(@input, 272)
  end

  @doc """
  iex> Day16.fill_and_checksum("10000", 20)
  "01100"
  """
  def fill_and_checksum(data, disk_length) do
    data
    |> String.codepoints
    |> fill(disk_length)
    |> checksum
  end

  def fill(data, disk_length) when length(data) >= disk_length do
    data
    |> Enum.take(disk_length)
    |> List.to_string
  end 
  def fill(data, disk_length) do
    data
    |> expand
    |> fill(disk_length)    
  end

  @doc """
  iex> Day16.expand("1") |> List.to_string
  "100"

  iex> Day16.expand("0") |> List.to_string
  "001"

  iex> Day16.expand("11111") |> List.to_string
  "11111000000"
  
  iex> Day16.expand("111100001010") |> List.to_string
  "1111000010100101011110000"
  """
  def expand(data) when is_binary(data), do: data |> String.codepoints |> expand
  def expand(data), do: expand(data, data, [])
  def expand([], a, b), do: a ++ ["0"] ++ b
  def expand(["0" | i], a, b), do: expand(i, a, ["1" | b])
  def expand(["1" | i], a, b), do: expand(i, a, ["0" | b])

  @doc """
  iex> Day16.checksum("110010110100")
  "100"
  """
  def checksum(data) do
    data
    |> String.codepoints
    |> Enum.chunk(2)
    |> checksum([])
    |> List.to_string
  end
  def checksum([], sum) when Integer.is_even(length(sum)) do
    sum 
    |> Enum.reverse
    |> Enum.chunk(2)
    |> checksum([])
  end
  def checksum([], sum), do: sum |> Enum.reverse 
  def checksum([[a, a] | rest], sum), do: checksum(rest, ["1" | sum])
  def checksum([_ | rest], sum), do: checksum(rest, ["0" | sum])

end