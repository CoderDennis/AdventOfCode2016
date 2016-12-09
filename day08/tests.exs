ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day08
end

#> elixir .\tests.exs