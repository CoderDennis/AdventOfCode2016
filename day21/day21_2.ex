defmodule Day21_2 do

  @doc """
  iex> Day21_2.descramble("bfheacgd")
  "abcdefgh"
  """
  def descramble(scrambled) do
    instructions = (File.stream!("input.txt")
    |> Enum.map(&String.trim/1))

    (for a <- ?a..?h,
        b <- ?a..?h,
        c <- ?a..?h,
        d <- ?a..?h,
        e <- ?a..?h,
        f <- ?a..?h,
        g <- ?a..?h,
        h <- ?a..?h,
        a != b,
        a != c,
        a != d,
        a != e,
        a != f,
        a != g,
        a != h,
        b != c,
        b != d,
        b != e,
        b != f,
        b != g,
        b != h,
        c != d,
        c != e,
        c != f,
        c != g,
        c != h,
        d != e,
        d != f,
        d != g,
        d != h,
        e != f,
        e != g,
        e != h,
        f != g,
        f != h,
        g != h,
      do: [a, b, c, d, e, f, g, h] |> Enum.map(&(<<&1>>)) |> List.to_string)
    |> Enum.find(&(Day21.scramble(&1, instructions) == scrambled))
  end

end