defmodule Dupper.Hasher do
  use GenServer, restart: :transient

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    send(self(), :do_hash)
    {:ok, nil}
  end

  def handle_info(:do_hash, _) do
    Dupper.FsTraverser.next_path()
    |> do_hash()
  end

  defp do_hash(nil) do
    Dupper.Collector.done()

    {:stop, :normal, nil}
  end

  defp do_hash(path) do
    Dupper.Collector.result(hash(path), path)
    send(self(), :do_hash)

    {:noreply, nil}
  end

  defp hash(path) do
    File.stream!(path, [], 4096 * 1024)
    |> Enum.reduce(
      :crypto.hash_init(:md5),
      fn blk, h ->
        :crypto.hash_update(h, blk)
      end
    )
    |> :crypto.hash_final()
  end
end
