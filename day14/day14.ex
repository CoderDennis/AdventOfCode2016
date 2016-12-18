defmodule Day14 do

  def puzzle_answer() do
    get_index_of_key_64("ahsbgdzn")
  end

  @doc """
  iex> Day14.get_index_of_key_64("abc")
  22551
  """
  def get_index_of_key_64(salt) do
    get_index_of_key_64(0, salt, MapSet.new(), %{})
  end

  def get_index_of_key_64(index, salt, keys_found, possible_keys) do
    if MapSet.size(keys_found) >= 64 do
      keys_found
      |> Enum.sort()
      |> Enum.at(63)
    else
      hash = get_stretched_hash(salt, index)
      get_index_of_key_64(
        index + 1,
        salt,
        MapSet.union(keys_found, get_matching_indexes_for_quintuplet(find_quintuplet(hash), possible_keys, index)),
        update_possible_keys(find_triplet(hash), possible_keys, index)
        )
    end
  end

  defp update_possible_keys(:none, possible_keys, _), do: possible_keys
  defp update_possible_keys({:ok, c}, possible_keys, index) do
    possible_keys
    |> Map.update(c, [index], &([index | &1]))
  end

  defp get_matching_indexes_for_quintuplet(:none, _, _), do: MapSet.new()
  defp get_matching_indexes_for_quintuplet({:ok, c}, possible_keys, index) do
    Map.get(possible_keys, c)
    |> get_matching_indexes_for_quintuplet(index)
  end
  defp get_matching_indexes_for_quintuplet(possible_indexes, index) do
    possible_indexes
    |> Enum.reverse()
    |> Enum.filter(&(&1 > (index - 1000)))
    |> MapSet.new()
  end

  @doc """
  iex> Day14.get_hash("abc", 18)
  "0034e0923cc38887a57bd7b1d4f953df"
  """
  def get_hash(salt, index) do
    get_hash("#{salt}#{index}")
  end

  @doc """
  iex> Day14.get_stretched_hash("abc", 0)
  "a107ff634856bb300138cac6568c0f24"
  """
  def get_stretched_hash(salt, index) do
    Stream.iterate(get_hash("#{salt}#{index}"), &get_hash/1)
    |> Stream.drop(2016)
    |> Enum.take(1)
    |> List.to_string
  end

  def get_hash(data) do
    :crypto.hash(:md5, data)
    |> Base.encode16
    |> String.downcase
  end

  @doc """
  iex> Day14.find_triplet("cc38887a5")
  {:ok, "8"}

  iex> Day14.find_triplet("abcddef123456")
  :none
  """
  def find_triplet(hash) do
    hash |> find_tuplet(3)
  end

  @doc """
  iex> Day14.find_quintuplet("cc3888887a5")
  {:ok, "8"}

  iex> Day14.find_quintuplet("abcdddef123456")
  :none
  """
  def find_quintuplet(hash) do
    hash |> find_tuplet(5)
  end

  defp find_tuplet(hash, x) do
    case Regex.run(~r/(.)\1{#{x-1}}/, hash) do
      [_, c] -> {:ok, c}
      nil -> :none
    end
  end

end
