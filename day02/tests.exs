ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day02
end

# run via:
#> elixirc .\day02.ex
#> elixir .\tests.exs