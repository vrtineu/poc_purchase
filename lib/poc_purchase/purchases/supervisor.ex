defmodule PocPurchase.Purchases.Supervisor do
  use Supervisor

  def start_link(options) do
    Supervisor.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(_options) do
    children = [
      {PocPurchase.Purchases.TransactionQueue, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
