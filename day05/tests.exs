ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day05
end

#> elixir .\tests.exs