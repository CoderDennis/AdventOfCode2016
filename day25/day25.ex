defmodule Day25 do

  def run_puzzle() do
    setup_registers
    instructions = File.stream!("input.txt")
    |> Stream.map(&(&1 |> String.strip |> parse_instruction))
    |> Enum.to_list
    Stream.iterate(1, &(&1 + 1))
    |> Stream.drop_while(&(run(&1, instructions) == :error))
    |> Enum.take(1)
  end

  def run(a, instructions) do
    IO.inspect a
    reset
    Register.set(:a, a)
    instructions
    |> run([], 0)
  end

  # def run(instructions, processed, jump)
  def run([], _, _), do: :error
  def run(instructions, [], jump) when jump < 0 do
    run(instructions, [], 0)
  end
  def run(instructions, [last | processed], jump) when jump < 0 do
    run([last | instructions], processed, jump + 1)
  end
  def run([next | instructions], processed, jump) when jump > 0 do
    run(instructions, [next | processed], jump - 1)
  end
  def run([{:copy, from, to_register} = current | remaining], processed, _) do
    # IO.inspect {:copy, current, remaining, processed}
    GenServer.call(to_register, {:set, get_value(from)})
    # IO.inspect %{a: get_value(:a),
    #              b: get_value(:b),
    #              c: get_value(:c),
    #              d: get_value(:d)}
    run(remaining, [current | processed], 0)
  end
  def run([{:jump, check, move} = current | remaining] = instructions, processed, _) do
    if get_value(check) == 0 do
      run(remaining, [current | processed], 0)
    else
      run(instructions, processed, move)
    end
  end
  def run([{:out, register} = current | remaining], processed, _) do
    case ClockSignalCollector.out(get_value(register)) do
      :ok -> run(remaining, [current | processed], 0)
      result -> result
    end
  end

  def run([{action, register} = current | remaining], processed, _) do
    # IO.inspect {action, current, remaining, processed}
    GenServer.call(register, action)
    # IO.inspect %{a: get_value(:a),
    #              b: get_value(:b),
    #              c: get_value(:c),
    #              d: get_value(:d)}
      run(remaining, [current | processed], 0)
  end

  def setup_registers() do
    [:a, :b, :c, :d]
    |> Enum.each(&Register.start_link/1)
    ClockSignalCollector.start_link
  end

  def reset() do
    [:a, :b, :c, :d]
    |> Enum.each(&(Register.set(&1, 0)))

    ClockSignalCollector.reset
  end

  def parse_instruction("inc " <> register), do: {:inc, register |> String.to_atom}
  def parse_instruction("dec " <> register), do: {:dec, register |> String.to_atom}
  def parse_instruction("cpy " <> instruction), do: instruction_to_tuple(:copy, instruction)
  def parse_instruction("jnz " <> instruction), do: instruction_to_tuple(:jump, instruction)
  def parse_instruction("out " <> instruction), do: instruction_to_tuple(:out , instruction)

  def instruction_to_tuple(name, instruction) do
    [name | instruction |> parse_values]
    |> List.to_tuple
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

  def set(name, value) do
    GenServer.call(name, {:set, value})
  end

  def handle_call({:set, v}, _from, _), do: {:reply, :ok, v}
  def handle_call(:get,      _from, v), do: {:reply, v,   v}
  def handle_call(:inc,      _from, v), do: {:reply, :ok, v+1}
  def handle_call(:dec,      _from, v), do: {:reply, :ok, v-1}

end

defmodule ClockSignalCollector do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, {0, 0}, name: __MODULE__)
  end

  def out(value) do
    GenServer.call(__MODULE__, {:out, value})
  end

  def reset() do
    GenServer.call(__MODULE__, :reset)
  end

  def handle_call({:out, expected}, _from, {expected, 1000} = state), do: {:reply, :done, state}
  def handle_call({:out, expected}, _from, {expected, count}), do: {:reply, :ok, {abs(expected - 1), count + 1}}
  def handle_call({:out, _}, _from, state), do: {:reply, :error, state}

  def handle_call(:reset, _from, _), do: {:reply, :ok, {0, 0}}

end