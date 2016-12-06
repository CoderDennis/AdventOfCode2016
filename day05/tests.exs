ExUnit.start(timeout: 160000)

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day05_2
end

#> elixir .\tests.exs