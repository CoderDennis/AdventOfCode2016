ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day06
end

#> elixir .\tests.exs