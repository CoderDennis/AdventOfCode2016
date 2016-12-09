ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day09
end

#> elixir .\tests.exs