defmodule Day07_2 do

  def puzzle_answer() do
    File.stream!("input.txt")
    |> Enum.count(&supports_ssl?/1)
  end

  @doc ~s"""
  iex> Day07_2.supports_ssl?("aba[bab]xyz")
  true

  iex> Day07_2.supports_ssl?("xyx[xyx]xyx")
  false

  iex> Day07_2.supports_ssl?("aaa[kek]eke")
  true

  iex> Day07_2.supports_ssl?("zazbz[bzb]cdb")
  true
  """
  def supports_ssl?(address) do
    supernet_abas = address
      |> supernet_sequences
      |> String.codepoints
      |> Enum.chunk(3,1)
      |> Enum.flat_map(&get_aba/1)
      |> MapSet.new
    hypernet_babs = address
      |> hypernet_sequences
      |> String.codepoints
      |> Enum.chunk(3,1)
      |> Enum.flat_map(&get_bab/1)
      |> MapSet.new
    !MapSet.disjoint?(supernet_abas, hypernet_babs)
  end

  @doc ~s"""
  iex> Day07_2.hypernet_sequences("abcd[bddb]xyyx[abcd]")
  "[bddb][abcd]"
  """
  def hypernet_sequences(address) do
    Regex.scan(~r/\[.*?\]/, address)
    |> List.to_string
  end

  @doc ~s"""
  iex> Day07_2.supernet_sequences("lknaffpzamlkufgt[uvdgeatxkofgoyoi]ajtqcsfdarjrddrzo[bxrcozuxifgevmog]rlyfschtnrklzufjzm")
  "lknaffpzamlkufgt|ajtqcsfdarjrddrzo|rlyfschtnrklzufjzm"
  """
  def supernet_sequences(address) do
    Regex.replace(~r/\[.*?\]/, address, "|")
  end


  @doc ~s"""
  iex> Day07_2.get_aba("aba" |> String.codepoints)
  [{"a", "b"}]

  iex> Day07_2.get_aba("aaa" |> String.codepoints)
  []

  iex> Day07_2.get_aba("abc" |> String.codepoints)
  []
  """
  def get_aba([a|[b|[a|[]]]]) when a != b, do: [{a, b}]
  def get_aba(_), do: []

  @doc """
  Swap position of a & b so that these can be matched with aba's.

  iex> Day07_2.get_bab("bab" |> String.codepoints)
  [{"a", "b"}]

  iex> Day07_2.get_bab("aaa" |> String.codepoints)
  []
  """
  def get_bab(possible_bab) do
    case get_aba(possible_bab) do
      [{a, b}] -> [{b, a}]
      n -> n
    end
  end

end