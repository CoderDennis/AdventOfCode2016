defmodule Day14 do

  # def puzzle_answer() do
  #   get_keys("ahsbgdzn")
  # end

  # @doc """
  # iex> Day14.get_keys("abc")
  # {
  # """
  # def get_keys(salt) do
    
  # end


  @doc """
  iex> Day14.get_hash("abc", 18) |> String.contains?("cc38887a5")
  true
  """
  def get_hash(salt, index) do
    :crypto.hash(:md5, "#{salt}#{index}")
    |> Base.encode16
    |> String.downcase
  end

end