ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day03
end

#> elixir .\tests.exs