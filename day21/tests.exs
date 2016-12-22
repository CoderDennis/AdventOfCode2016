ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day21
end

#> elixir .\tests.exs