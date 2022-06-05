defmodule Dupper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Dupper.Result, name: Dupper.Result},
      {Dupper.FsTraverser, name: Dupper.FsTraverser},
      {Dupper.HasherSupervisor, name: Dupper.HasherSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Dupper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
