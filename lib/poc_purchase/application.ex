defmodule PocPurchase.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PocPurchaseWeb.Telemetry,
      PocPurchase.Repo,
      {DNSCluster, query: Application.get_env(:poc_purchase, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PocPurchase.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PocPurchase.Finch},
      # Start a worker by calling: PocPurchase.Worker.start_link(arg)
      # {PocPurchase.Worker, arg},
      # Start to serve requests, typically the last entry
      PocPurchaseWeb.Endpoint,
      PocPurchase.Purchases.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PocPurchase.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PocPurchaseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
