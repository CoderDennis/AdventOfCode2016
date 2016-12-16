ExUnit.start

defmodule Tests do
  use ExUnit.Case, async: true
  doctest Day16
end

#> elixir .\tests.exs