defmodule PocPurchase.Purchases.Supervisor do
  use Supervisor

  alias PocPurchase.Purchases.{PaymentQueue, TransactionProcessor, TransactionQueue}

  def start_link(options) do
    Supervisor.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(_options) do
    children = [
      {TransactionQueue, []},
      {TransactionProcessor, subscribe_to: [{TransactionQueue, max_demand: 10}]},
      {PaymentQueue, subscribe_to: [{TransactionProcessor, max_demand: 10}]}
    ]

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end
end
