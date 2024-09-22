defmodule PocPurchaseWeb.TransactionJSON do
  alias PocPurchase.Transactions.{Transaction, TransactionProduct}

  @doc """
  Renders a list of transactions.
  """
  def index(%{transactions: transactions}) do
    %{data: for(transaction <- transactions, do: data(transaction))}
  end

  @doc """
  Renders a single transaction.
  """
  def show(%{transaction: transaction}) do
    %{data: data(transaction)}
  end

  defp data(%Transaction{} = transaction) do
    %{
      id: transaction.id,
      status: transaction.status,
      trasaction_products:
        for(product <- transaction.transaction_products, do: transaction_products_data(product))
    }
  end

  defp transaction_products_data(%TransactionProduct{} = product) do
    %{
      id: product.id,
      quantity: product.quantity,
      thirdparty_id: product.thirdparty_id
    }
  end
end
