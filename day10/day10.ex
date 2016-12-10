defmodule Day10 do

  def run_puzzle() do
    File.stream!("input.txt")
    |> Stream.each(&process_instruction/1)
    |> Stream.run
  end

  def run_sample() do
    File.stream!("sample.txt")
    |> Stream.each(&process_instruction/1)
    |> Stream.run
  end

  def process_instruction("value " <> instruction) do
    [_, value, bot] = Regex.run(~r/(\d+) goes to bot (\d+)/, instruction)
    ensure_created("bot", bot)
    GenServer.cast(Bot.bot_name(bot), {:value, value |> String.to_integer})
  end
  def process_instruction("bot " <> instruction) do
    [_, bot, low_type, low, high_type, high] =
      Regex.run(~r/(\d+) gives low to (\w+) (\d+) and high to (\w+) (\d+)/, instruction)
    ensure_created("bot", bot)
    ensure_created(low_type, low)
    ensure_created(high_type, high)
    GenServer.cast(Bot.bot_name(bot),
      {:gives_to,
       "#{low_type}_#{low}" |> String.to_atom,
       "#{high_type}_#{high}" |> String.to_atom})
  end

  defp ensure_created("bot", number) do
    if Process.whereis(Bot.bot_name(number)) == nil do
      Bot.start_link(number)
    end
    :ok
  end
  defp ensure_created("output", number) do
    if Process.whereis(Output.output_name(number)) == nil do
      Output.start_link(number)
    end
    :ok
  end

end

defmodule Bot do
  use GenServer
  defstruct [:number, :values, :low_to, :high_to]

  def start_link(bot_number) do
    GenServer.start_link(__MODULE__,
      %Bot{number: bot_number, values: []},
      name: bot_name(bot_number))
  end

  def bot_name(number), do: "bot_#{number}" |> String.to_atom

  def handle_cast({:value, v}, %Bot{values: []} = state) do
    {:noreply, %{state | values: [v]}}
  end
  def handle_cast({:value, v}, state) do
    values = [v | state.values]
    {:noreply, give_values(%{state | values: values})}
  end

  def handle_cast({:gives_to, low, high}, state) do
    {:noreply, give_values(%{state | low_to: low, high_to: high})}
  end

  defp give_values(%Bot{values: []} = state), do: state
  defp give_values(%Bot{values: [_]} = state), do: state
  defp give_values(%Bot{low_to: low} = state) when low == nil, do: state
  defp give_values(%Bot{values: [a, b]} = state) do
    IO.puts("bot #{state.number} comparing #{a} and #{b}")
    GenServer.cast(state.low_to,  {:value, Enum.min(state.values)})
    GenServer.cast(state.high_to, {:value, Enum.max(state.values)})
    %{state | values: []}
  end
end

defmodule Output do
  use GenServer
  defstruct [:number, :values]

  def start_link(output_number) do
    GenServer.start_link(__MODULE__,
      %Output{number: output_number, values: []},
      name: output_name(output_number))
  end

  def output_name(number), do: "output_#{number}" |> String.to_atom

  def handle_cast({:value, v}, %Output{number: number, values: values} = state) do
    IO.puts("output #{number} got value #{v}")
    {:noreply, %{state | values: [v | values]}}
  end
end
