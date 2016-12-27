ExUnit.start(timeout: 160000)

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day21_2
end

#> elixir .\tests.exs