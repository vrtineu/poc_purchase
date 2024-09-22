defmodule PocPurchase.Purchases.TransactionProcessor do
  use GenStage

  alias PocPurchase.Orders.Order

  require Logger

  def start_link(options) do
    GenStage.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(options) do
    Logger.info("Starting TransactionProcessor with options: #{inspect(options)}")

    subscribe_to = Keyword.get(options, :subscribe_to, [])
    {:producer_consumer, :ok, subscribe_to: subscribe_to}
  end

  @impl true
  def handle_events(events, _from, state) do
    Logger.debug("Received events to process: #{inspect(events)}")

    events =
      Enum.reduce(events, [], fn event, acc_events ->
        case process_event(event) do
          {:ok, order} ->
            [order | acc_events]

          {:error, reason} ->
            Logger.error("Error processing event: #{inspect(event)} - #{reason}")
            acc_events
        end
      end)

    {:noreply, Enum.reverse(events), state}
  end

  defp process_event(_event) do
    # mocking for now
    {:ok, %Order{status: "pending", total_amount: Decimal.new(15)}}
  end
end
