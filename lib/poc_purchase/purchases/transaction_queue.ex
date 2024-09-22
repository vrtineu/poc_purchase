defmodule PocPurchase.Purchases.TransactionQueue do
  use GenStage

  require Logger

  def start_link(options) do
    GenStage.start_link(__MODULE__, options, name: {:global, __MODULE__})
  end

  @impl true
  def init(_options) do
    Logger.info("Starting TransactionQueue module")

    {:producer, {:queue.new(), 0}}
  end

  ##############
  # Public API #
  ##############

  def add_event(event) do
    GenStage.cast(__MODULE__, {:new_event, event})
  end

  ###############
  # Private API #
  ###############

  @impl true
  def handle_demand(demand, {queue, pending_demand}) do
    {events, new_queue, new_demand} = take_events_from_queue(queue, demand + pending_demand, [])
    {:noreply, events, {new_queue, new_demand}}
  end

  @impl true
  def handle_cast({:new_event, event}, {queue, pending_demand}) do
    Logger.debug("Received new event: #{inspect(event)}")

    new_queue = queue.in(:queue, event)
    {events, new_queue, new_demand} = take_events_from_queue(new_queue, pending_demand, [])
    {:noreply, events, {new_queue, new_demand}}
  end

  defp take_events_from_queue(queue, demand, events) do
    case queue.out(queue) do
      {{:value, event}, new_queue} ->
        take_events_from_queue(new_queue, demand - 1, [event | events])

      _ ->
        {Enum.reverse(events), queue, demand}
    end
  end
end
