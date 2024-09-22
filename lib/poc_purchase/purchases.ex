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
    Repo.transaction(fn ->
      attrs = %{
        status: :pending,
        transaction_products: transaction_products_params
      }

      with transaction <- Transactions.get_transaction!(id),
           {:ok, transaction} <- Transactions.update_transaction(transaction, attrs) do
        transaction = Repo.preload(transaction, :transaction_products)
        TransactionQueue.add_event(transaction)

        transaction
      else
        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end
end
