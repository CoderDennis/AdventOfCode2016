defmodule Day21_2 do

  @doc """
  iex> Day21_2.descramble("bfheacgd")
  "abcdefgh"
  """
  def descramble(scrambled) do
    File.stream!("input.txt")
    |> Enum.reverse
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(scrambled, &undo/2)
  end

  @doc """
  iex> Day21_2.undo("swap position 4 with position 0", "abcde")
  "ebcda"

  iex> Day21_2.undo("swap position 3 with position 1", "adcbe")
  "abcde"

  iex> Day21_2.undo("swap letter d with letter b", "edcba")
  "ebcda"

  iex> Day21_2.undo("reverse positions 0 through 4", "abcde")
  "edcba"

  iex> Day21_2.undo("reverse positions 1 through 2", "acbde")
  "abcde"

  iex> Day21_2.undo("rotate left 1 step", "bcdea")
  "abcde"

  iex> Day21_2.undo("rotate right 1 step", "dabc")
  "abcd"

  iex> Day21_2.undo("move position 1 to position 4", "bdeac")
  "bcdea"

  iex> Day21_2.undo("move position 3 to position 0", "abdec")
  "bdeac"

  iex> Day21_2.undo("move position 3 to position 1", "adbce")
  "abcde"

  iex> Day21_2.undo("rotate based on position of letter b", "ecabd")
  "abdec"

  iex> Day21_2.undo("rotate based on position of letter d", "decab")
  "ecabd"
  """
  def undo("swap position " <> <<x_str::bytes-size(1)>> <> " with position " <> <<y_str::bytes-size(1)>>, password) do
    [x, y] = get_integers([x_str, y_str]) |> Enum.sort
    [_, a, x_val, b, y_val, c] = Regex.run(~r/(.{#{x}})(.)(.{#{y-x-1}})(.)(.*)/, password)
    [   a, y_val, b, x_val, c] |> List.to_string
  end
  def undo("swap letter " <> <<x::bytes-size(1)>> <> " with letter " <> <<y::bytes-size(1)>>, password) do
    password
    |> String.replace(x, " ")
    |> String.replace(y, x)
    |> String.replace(" ", y)
  end
  def undo("reverse positions " <> <<x_str::bytes-size(1)>> <> " through " <> <<y_str::bytes-size(1)>>, password) do
    [x, y] = get_integers([x_str, y_str]) |> Enum.sort
    [_, a, b, c] = Regex.run(~r/(.{#{x}})(.{#{y-x+1}})(.*)/, password)
    [a, b |> String.reverse, c] |> List.to_string
  end
  def undo("rotate left " <> <<x_str::bytes-size(1)>> <> _, password) do
    password
    |> rotate_right(x_str |> String.to_integer)
  end
  def undo("rotate right " <> <<x_str::bytes-size(1)>> <> _, password) do
    password
    |> rotate_left(x_str |> String.to_integer)
  end
  def undo("move position " <> <<x_str::bytes-size(1)>> <> " to position " <> <<y_str::bytes-size(1)>>, password) do
    [x, y] = get_integers([x_str, y_str])
    password
    |> move(y, x)
  end
  def undo("rotate based on position of letter " <> <<letter::bytes-size(1)>>, password) do
    x = password |> index_of(letter)
    password
    |> rotate_left(adjust_letter_position(x))
  end

  def get_integers(list_of_strings) do
    list_of_strings
    |> Enum.map(&String.to_integer/1)
  end

  def rotate_left(password, 0), do: password
  def rotate_left(<<x::bytes-size(1)>> <> rest, count) do
    rotate_left(rest <> x, count - 1)
  end

  def rotate_right(password, 0), do: password
  def rotate_right(password, count) do
    {a, b} = password |> String.split_at(-1)
    [b, a]
    |> List.to_string
    |> rotate_right(count - 1)
  end

  def move(password, x, y) when y < x do
    letter = password |> String.at(x)
    {a, b} = password |> String.split_at(y)
    [a, letter, b |> String.replace(letter, "")]
    |> List.to_string
  end
  def move(password, x, y) do
    letter = password |> String.at(x)
    {a, b} = password |> String.split_at(y + 1)
    [a |> String.replace(letter, ""), letter, b]
    |> List.to_string
  end

  @doc """
  iex> Day21_2.index_of("abcde", "c")
  2
  """
  def index_of(string, sub_string) do
    [_, a] = String.split(string, sub_string)
    a |> String.length
  end

  def adjust_letter_position(x) when x < 4, do: x + 2
  def adjust_letter_position(x), do: x + 1

end