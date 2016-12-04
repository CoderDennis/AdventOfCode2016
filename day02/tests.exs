ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day02
  doctest Day02_2
end

# run via:
#> elixirc .\day02.ex
#> elixir .\tests.exs