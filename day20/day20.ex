defmodule Day20 do

  @sample ["5-8",
           "0-2",
           "4-7"]

  # for line <- @sample do
  # for line <- File.stream!("input.txt") do
  #   [_, min, max] = Regex.run(~r/(\d+)-(\d+)/, line)
  # end

  for line <- File.stream!("input.txt") do
    [_, min_str, max_str] = Regex.run(~r/(\d+)-(\d+)/, line)
    min = min_str |> String.to_integer
    max = max_str |> String.to_integer
    def blocked?(ip) when ip >= unquote(min) and ip <= unquote(max), do: true
    def skip_blocked(ip) when ip >= unquote(min) and ip < unquote(max), do: skip_blocked(unquote(max))
  end
  def blocked?(_), do: false
  def skip_blocked(ip), do: ip + 1

  def first_unblocked(start \\ 0) do
    Stream.iterate(start, &(&1+1))
    |> Enum.find(&(not blocked?(&1)))
  end

  def count_unblocked() do
    Stream.iterate(0, &skip_blocked/1)
    |> Stream.filter(&(not blocked?(&1)))
    |> Stream.take_while(&(&1 <= 4294967295))
    |> Enum.count
  end

end
