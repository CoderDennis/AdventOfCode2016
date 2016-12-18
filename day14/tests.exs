ExUnit.start(timeout: 1000000)

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day14
end

#> elixir .\tests.exs