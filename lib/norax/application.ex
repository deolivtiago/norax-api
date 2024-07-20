defmodule NoraxCore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NoraxCoreWeb.Telemetry,
      NoraxCore.Repo,
      {DNSCluster, query: Application.get_env(:norax, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: NoraxCore.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: NoraxCore.Finch},
      # Start a worker by calling: NoraxCore.Worker.start_link(arg)
      # {NoraxCore.Worker, arg},
      # Start to serve requests, typically the last entry
      NoraxCoreWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NoraxCore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NoraxCoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
