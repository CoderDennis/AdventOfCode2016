ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day22
end

#> elixir .\tests.exs