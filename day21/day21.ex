defmodule Day21 do

  def run() do
    scramble("abcdefgh", "input.txt")
  end

  @doc """
  iex> Day21.scramble("abcde", "example.txt")
  "decab"
  """
  def scramble(password, instructions) when is_list instructions do
    instructions
    |> Enum.reduce(password, &perform/2)
  end
  def scramble(password, instructions_file) do
    instructions = (File.stream!(instructions_file)
    |> Enum.map(&String.trim/1))
    scramble(password, instructions)
  end

  # def perform(instruction, password) ...
  @doc """
  iex> Day21.perform("swap position 4 with position 0", "abcde")
  "ebcda"

  iex> Day21.perform("swap position 3 with position 1", "abcde")
  "adcbe"

  iex> Day21.perform("swap letter d with letter b", "ebcda")
  "edcba"

  iex> Day21.perform("reverse positions 0 through 4", "edcba")
  "abcde"

  iex> Day21.perform("reverse positions 1 through 2", "abcde")
  "acbde"

  iex> Day21.perform("rotate left 1 step", "abcde")
  "bcdea"

  iex> Day21.perform("rotate right 1 step", "abcd")
  "dabc"

  iex> Day21.perform("move position 1 to position 4", "bcdea")
  "bdeac"

  iex> Day21.perform("move position 3 to position 0", "bdeac")
  "abdec"

  iex> Day21.perform("move position 3 to position 1", "abcde")
  "adbce"

  iex> Day21.perform("rotate based on position of letter b", "abdec")
  "ecabd"

  iex> Day21.perform("rotate based on position of letter d", "ecabd")
  "decab"

  """
  def perform("swap position " <> <<x_str::bytes-size(1)>> <> " with position " <> <<y_str::bytes-size(1)>>, password) do
    [x, y] = get_integers([x_str, y_str]) |> Enum.sort
    [_, a, x_val, b, y_val, c] = Regex.run(~r/(.{#{x}})(.)(.{#{y-x-1}})(.)(.*)/, password)
    [   a, y_val, b, x_val, c] |> List.to_string
  end
  def perform("swap letter " <> <<x::bytes-size(1)>> <> " with letter " <> <<y::bytes-size(1)>>, password) do
    password
    |> String.replace(x, " ")
    |> String.replace(y, x)
    |> String.replace(" ", y)
  end
  def perform("reverse positions " <> <<x_str::bytes-size(1)>> <> " through " <> <<y_str::bytes-size(1)>>, password) do
    [x, y] = get_integers([x_str, y_str]) |> Enum.sort
    [_, a, b, c] = Regex.run(~r/(.{#{x}})(.{#{y-x+1}})(.*)/, password)
    [a, b |> String.reverse, c] |> List.to_string
  end
  def perform("rotate left " <> <<x_str::bytes-size(1)>> <> _, password) do
    password
    |> rotate_left(x_str |> String.to_integer)
  end
  def perform("rotate right " <> <<x_str::bytes-size(1)>> <> _, password) do
    password
    |> rotate_right(x_str |> String.to_integer)
  end
  def perform("move position " <> <<x_str::bytes-size(1)>> <> " to position " <> <<y_str::bytes-size(1)>>, password) do
    [x, y] = get_integers([x_str, y_str])
    password
    |> move(x, y)
  end
  def perform("rotate based on position of letter " <> <<letter::bytes-size(1)>>, password) do
    x = password |> index_of(letter)
    password
    |> rotate_right(adjust_letter_position(x))
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
  iex> Day21.index_of("abcde", "c")
  2
  """
  def index_of(string, sub_string) do
    [a, _] = String.split(string, sub_string)
    a |> String.length
  end

  def adjust_letter_position(x) when x < 4, do: x + 1
  def adjust_letter_position(x), do: x + 2

end