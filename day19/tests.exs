ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day19
end

#> elixir .\tests.exs