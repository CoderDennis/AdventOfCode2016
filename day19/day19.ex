defmodule Day19 do

  def run(elf_count) do
    1..elf_count
    |> Enum.each(fn n -> Elf.start(n, elf_count) end)
    GenServer.cast(:elf1, :go)
  end

end

defmodule Elf do
  use GenServer
  defstruct [:number, :count, :presents]

  def start(number, count) do
    GenServer.start(__MODULE__,
      %Elf{number: number, count: count, presents: 1},
      name: elf_name(number))
  end

  defp elf_name(number) do
    "elf#{number}" |> String.to_atom
  end

  def handle_cast(:go, %Elf{number: n, count: p, presents: p} = state) do
    IO.inspect n
    {:noreply, state}
  end
  def handle_cast(:go, %Elf{number: n, count: n, presents: 0} = state) do
    GenServer.cast(:elf1, :go)
    {:noreply, state}
  end
  def handle_cast(:go, %Elf{number: n, presents: 0} = state) do
    GenServer.cast(elf_name(n+1), :go)
    {:noreply, state}
  end
  def handle_cast(:go, %Elf{number: n, count: n, presents: p} = state) do
    taken_presents = GenServer.call(:elf1, :take)
    GenServer.cast(:elf1, :go)
    {:noreply, %{state | presents: p + taken_presents}}
  end
  def handle_cast(:go, %Elf{number: n, presents: p} = state) do
    taken_presents = GenServer.call(elf_name(n + 1), :take)
    GenServer.cast(elf_name(n + 1), :go)
    {:noreply, %{state | presents: p + taken_presents}}
  end

  def handle_call(:take, _from, %Elf{number: n, count: n, presents: 0} = state) do
    {:reply, GenServer.call(:elf1, :take), state}
  end
  def handle_call(:take, _from, %Elf{number: n, presents: 0} = state) do
    {:reply, GenServer.call(elf_name(n + 1), :take), state}
  end
  def handle_call(:take, _from, %Elf{presents: p} = state) do
    {:reply, p, %{state | presents: 0}}
  end

end