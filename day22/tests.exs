ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day22_2
  doctest GridNode
end

#> elixir .\tests.exs