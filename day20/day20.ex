defmodule Day20 do

  @sample ["5-8",
           "0-2",
           "4-7"]

  # for line <- @sample do
  for line <- File.stream!("input.txt") do
    [_, min, max] = Regex.run(~r/(\d+)-(\d+)/, line)
    def blocked?(ip) when ip >= unquote(min |> String.to_integer) and ip <= unquote(max |> String.to_integer), do: true
  end
  def blocked?(_), do: false

  def first_unblocked() do
    Stream.iterate(0, &(&1+1))
    |> Enum.find(&(not blocked?(&1)))
  end

end
