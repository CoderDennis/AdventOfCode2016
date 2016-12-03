ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day01
end

# run via:
#> elixirc .\day01.ex
#> elixir .\tests.exs