defmodule Dupper.Collector do
  use GenServer

  def start_link(opts \\ [hasher_count: 4, name: __MODULE__]) do
    {hasher_count, opts} = Keyword.pop(opts, :hasher_count)
    GenServer.start_link(__MODULE__, hasher_count, opts)
  end

  def done(pid \\ __MODULE__) do
    GenServer.cast(pid, :done)
  end

  def result(pid \\ __MODULE__, hash, path) do
    GenServer.cast(pid, {:result, hash, path})
  end

  def init(hasher_count) do
    send(self(), :hasher_init)
    {:ok, hasher_count}
  end

  def handle_cast(:done, _hasher_count = 1) do
    report_result()
    System.halt(0)
  end

  def handle_cast(:done, hasher_count) do
    {:noreply, hasher_count - 1}
  end

  def handle_cast({:result, hash, path}, hasher_count) do
    Dupper.Result.add_hash(hash, path)

    {:noreply, hasher_count}
  end

  def handle_info(:hasher_init, hasher_count) do
    1..hasher_count
    |> Enum.each(fn _ -> Dupper.HasherSupervisor.add_worker() end)

    {:noreply, hasher_count}
  end

  defp report_result() do
    IO.puts("Results:\n")

    Dupper.Result.duplicates()
    |> Enum.each(&IO.inspect/1)
  end
end
