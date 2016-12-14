ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day13
end

#> elixir .\tests.exs