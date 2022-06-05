defmodule Dupper.HasherSupervisor do
  use DynamicSupervisor

  def start_link(opts \\ [name: __MODULE__]) do
    DynamicSupervisor.start_link(__MODULE__, nil, opts)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_worker() do
    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, Dupper.Hasher)
  end
end
