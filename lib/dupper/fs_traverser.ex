defmodule Dupper.FsTraverser do
  use GenServer

  @default_root "."

  def start_link(opts \\ [root: ".", name: __MODULE__]) do
    {root, opts} = Keyword.pop(opts, :root, @default_root)
    GenServer.start_link(__MODULE__, root, opts)
  end

  def next_path(pid \\ __MODULE__) do
    GenServer.call(pid, :next_path)
  end

  def init(root) do
    DirWalker.start_link(root)
  end

  def handle_call(:next_path, _caller, walker) do
    path =
      case DirWalker.next(walker) do
        [path] -> path
        other -> other
      end

    {:reply, path, walker}
  end
end
