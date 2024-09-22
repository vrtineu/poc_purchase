defmodule PocPurchase.Purchases.PaymentQueue do
  use GenStage

  require Logger

  def start_link(options) do
    GenStage.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(options) do
    Logger.info("Starting PaymentQueue with options: #{inspect(options)}")

    subscribe_to = Keyword.get(options, :subscribe_to, [])
    {:consumer, :ok, subscribe_to: subscribe_to}
  end

  @impl true
  def handle_events(events, _from, state) do
    Logger.debug("Received events: #{inspect(events)}")

    Enum.each(events, &inspect/1)
    {:noreply,  [], state}
  end
end
