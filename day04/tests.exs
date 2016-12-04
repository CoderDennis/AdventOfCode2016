ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day04
end

#> elixir .\tests.exs