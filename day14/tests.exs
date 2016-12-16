ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day14
end

#> elixir .\tests.exs