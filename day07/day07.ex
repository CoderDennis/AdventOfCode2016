defmodule Day07 do

  def puzzle_answer() do
    File.stream!("input.txt")
    |> Enum.count(&supports_tls?/1)
  end

  @doc ~s"""
  iex> Day07.supports_tls?("abba[mnop]qrst")
  true

  iex> Day07.supports_tls?("abcd[bddb]xyyx")
  false

  iex> Day07.supports_tls?("aaaa[qwer]tyui")
  false

  iex> Day07.supports_tls?("ioxxoj[asdfgh]zxcvbn")
  true

  iex> Day07.supports_tls?("ixoj[asdfgh]jocvbn")
  false
  """
  def supports_tls?(address) do
    no_abba_within_hypernet_sequences?(address) &&
    abba_outside_hypernet_sequences?(address)
  end

  defp no_abba_within_hypernet_sequences?(address) do
    !(address
    |> extract_hypernet_sequences
    |> contains_abba?)
  end

  defp abba_outside_hypernet_sequences?(address) do
    address
    |> remove_hypernet_sequences
    |> contains_abba?
  end

  defp contains_abba?(address) do
    address
    |> String.codepoints
    |> Enum.chunk(4,1)
    |> Enum.any?(&is_abba?/1)
  end

  @doc ~s"""
  iex> Day07.extract_hypernet_sequences("abcd[bddb]xyyx[abcd]")
  "[bddb][abcd]"
  """
  def extract_hypernet_sequences(address) do
    Regex.scan(~r/\[.*?\]/, address)
    |> List.to_string
  end

  @doc ~s"""
  iex> Day07.remove_hypernet_sequences("lknaffpzamlkufgt[uvdgeatxkofgoyoi]ajtqcsfdarjrddrzo[bxrcozuxifgevmog]rlyfschtnrklzufjzm")
  "lknaffpzamlkufgt|ajtqcsfdarjrddrzo|rlyfschtnrklzufjzm"
  """
  def remove_hypernet_sequences(address) do
    Regex.replace(~r/\[.*?\]/, address, "|")
  end

  @doc ~s"""
  iex> Day07.is_abba?("abba" |> String.codepoints)
  true

  iex> Day07.is_abba?("aaaa" |> String.codepoints)
  false

  iex> Day07.is_abba?("abcd" |> String.codepoints)
  false
  """
  def is_abba?([a|[b|[b|[a|[]]]]]) when a != b, do: true
  def is_abba?(_), do: false

end