ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day15
end

#> elixir .\tests.exs