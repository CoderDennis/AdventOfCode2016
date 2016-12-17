ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day17
end

#> elixir .\tests.exs