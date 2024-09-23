defmodule PocPurchase.Purchases do
  @moduledoc """
  Purchases contexts
  """

  alias PocPurchase.Purchases.TransactionQueue
  alias PocPurchase.Repo
  alias PocPurchase.Transactions.Transaction
  alias PocPurchase.Transactions

  @doc """
  Starts a new transaction with active status
  """
  def start_transaction() do
    %Transaction{status: :active}
    |> Transaction.changeset(%{})
    |> Repo.insert()
  end

  def init_processors(id, transaction_products_params) do
    transaction = Transactions.get_transaction!(id, preloads: [:transaction_products])

    if transaction_can_be_processed?(transaction) do
      Repo.transaction(fn ->
        attrs = %{
          status: :pending,
          transaction_products: transaction_products_params
        }

        case Transactions.update_transaction(transaction, attrs) do
          {:ok, transaction} ->
            transaction = Repo.preload(transaction, :transaction_products)
            TransactionQueue.add_event(transaction)
            transaction

          {:error, changeset} ->
            Repo.rollback(changeset)
        end
      end)
    else
      {:error, :already_processed}
    end
  end

  defp transaction_can_be_processed?(%Transaction{status: status}), do: status == :active
  defp transaction_can_be_processed?(_), do: false
end
