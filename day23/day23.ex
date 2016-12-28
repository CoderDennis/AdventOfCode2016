defmodule Day23 do

  def run_puzzle() do
    setup_registers
    GenServer.call(:c, {:set, 7})
    File.stream!("input.txt")
    |> run
  end

  def run_sample() do
    setup_registers
    File.stream!("sample.txt")
    |> run
  end

  def run(instructions) do
    instructions
    |> Stream.map(&(&1 |> String.strip |> parse_instruction))
    |> Enum.to_list
    |> run([], 0)
    GenServer.call(:a, :get)
  end

  # def run(instructions, processed, jump)
  def run([], _, _), do: :ok
  def run(instructions, [], jump) when jump < 0 do
    run(instructions, [], 0)
  end
  def run(instructions, [last | processed], jump) when jump < 0 do
    run([last | instructions], processed, jump + 1)
  end
  def run([next | instructions], processed, jump) when jump > 0 do
    run(instructions, [next | processed], jump - 1)
  end
  def run([{false, {:copy, from, to_register}} = current | remaining], processed, _) when is_atom to_register do
    GenServer.call(to_register, {:set, get_value(from)})
    run(remaining, [current | processed], 0)
  end
  def run([{false, {:copy, _, _}} = current | remaining], processed, _) do
    # skip invalid copy
    run(remaining, [current | processed], 0)
  end
  def run([{false, {:jump, check, move}} = current | remaining] = instructions, processed, _) do
    if get_value(check) == 0 do
      run(remaining, [current | processed], 0)
    else
      run(instructions, processed, move)
    end
  end
  def run([{false, {:toggle, x}} = current | remaining], processed, _) do
    {current, remaining, processed} = (get_value(x)
    |> toggle(current, remaining, processed))
    run(remaining, [current | processed], 0)
  end
  def run([{false, {action, register}} = current | remaining], processed, _) do
    GenServer.call(register, action)
    run(remaining, [current | processed], 0)
  end
  def run([{true, {:inc, a}} | remaining], processed, _) do
    run([{false, {:dec, a}} | remaining], processed, 0)
  end
  def run([{true, {_, a}} | remaining], processed, _) do
    run([{false, {:inc, a}} | remaining], processed, 0)
  end
  def run([{true, {:jump, a, b}} | remaining], processed, _) do
    run([{false, :copy, a, b} | remaining], processed, 0)
  end
  def run([{true, {_, a, b}} | remaining], processed, _) do
    run([{false, {:jump, a, b}} | remaining], processed, 0)
  end

  def toggle(0, {_, instruction}, remaining, processed) do
    {{true, instruction}, remaining, processed}
  end
  def toggle(value, current, remaining, processed) when value > 0 do
    {current, toggle(remaining, value), processed}
  end
  def toggle(value, current, remaining, processed) do
    {current, remaining, toggle(processed, value)}
  end

  def toggle(list, count) when length(list) <= count do
    {a, [{_, instruction} | remaining]} = Enum.split(list, count - 1)
    a ++ [{true, instruction} | remaining]
  end
  def toggle(list, _), do: list

  def setup_registers() do
    [:a, :b, :c, :d]
    |> Enum.each(&Register.start_link/1)
  end

  def parse_instruction("inc " <> register), do: {false, {:inc, register |> String.to_atom}}
  def parse_instruction("dec " <> register), do: {false, {:dec, register |> String.to_atom}}
  def parse_instruction("cpy " <> instruction) do
    {false, [:copy | instruction |> parse_values] |> List.to_tuple}
  end
  def parse_instruction("jnz " <> instruction) do
    {false, [:jump | instruction |> parse_values] |> List.to_tuple}
  end
  def parse_instruction("tgl " <> instruction) do
    {false, [:toggle | instruction |> parse_values] |> List.to_tuple}
  end

  def parse_values(values) do
    values
    |> String.split(" ")
    |> Enum.map(&parse_value/1)
  end
  def parse_value(v) do
    case Integer.parse(v) do
      :error -> v |> String.to_atom
      {i, _} -> i
    end
  end

  def get_value(r) when is_atom(r), do: GenServer.call(r, :get)
  def get_value(v), do: v

end

defmodule Register do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, 0, name: name)
  end

  def handle_call({:set, v}, _from, _), do: {:reply, :ok, v}
  def handle_call(:get,      _from, v), do: {:reply, v,   v}
  def handle_call(:inc,      _from, v), do: {:reply, :ok, v+1}
  def handle_call(:dec,      _from, v), do: {:reply, :ok, v-1}

end