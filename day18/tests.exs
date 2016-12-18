ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day18
end

#> elixir .\tests.exs