defmodule Dupper.Result do
  use GenServer

  # API
  def start_link(opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, :no_args, opts)
  end

  def add_hash(pid \\ __MODULE__, hash, path) do
    GenServer.cast(pid, {:add, hash, path})
  end

  def duplicates(pid \\ __MODULE__) do
    GenServer.call(pid, :duplicates)
  end

  # Server
  def init(:no_args) do
    {:ok, %{}}
  end

  def handle_cast({:add, hash, path}, results) do
    results =
      Map.update(
        results,
        hash,
        [path],
        fn paths -> [path | paths] end
      )

    {:noreply, results}
  end

  def handle_call(:duplicates, _caller, results) do
    {
      :reply,
      hashes_with_duplicates(results),
      results
    }
  end

  defp hashes_with_duplicates(results) do
    for {_hash, paths} <- results,
        length(paths) > 1,
        do: paths
  end
end
