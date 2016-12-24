defmodule Day23 do

  def run_puzzle() do
    File.stream!("input.txt")
    |> run
  end

  def run_sample() do
    File.stream!("sample.txt")
    |> run
  end

  def run(instructions) do
    setup_registers
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
    GenServer.call(:c, {:set, 1})
  end

  def parse_instruction("inc " <> register), do: {:inc, register |> String.to_atom}
  def parse_instruction("dec " <> register), do: {:dec, register |> String.to_atom}
  def parse_instruction("cpy " <> instruction) do
    [:copy | instruction |> parse_values]
    |> List.to_tuple
  end
  def parse_instruction("jnz " <> instruction) do
    [:jump | instruction |> parse_values]
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

  def handle_call({:set, v}, _from, _), do: {:reply, :ok, v}
  def handle_call(:get,      _from, v), do: {:reply, v,   v}
  def handle_call(:inc,      _from, v), do: {:reply, :ok, v+1}
  def handle_call(:dec,      _from, v), do: {:reply, :ok, v-1}

end