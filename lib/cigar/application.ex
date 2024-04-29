defmodule Cigar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CigarWeb.Telemetry,
      Cigar.Repo,
      {DNSCluster, query: Application.get_env(:cigar, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cigar.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cigar.Finch},
      # Start a worker by calling: Cigar.Worker.start_link(arg)
      # {Cigar.Worker, arg},
      # Start to serve requests, typically the last entry
      CigarWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cigar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CigarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
