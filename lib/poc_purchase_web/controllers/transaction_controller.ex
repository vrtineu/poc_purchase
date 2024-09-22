defmodule PocPurchaseWeb.TransactionController do
  use PocPurchaseWeb, :controller

  alias PocPurchase.Purchases
  alias PocPurchase.Transactions

  action_fallback PocPurchaseWeb.FallbackController

  def show(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)
    render(conn, :show, transaction: transaction)
  end

  def start(conn, _params) do
    with {:ok, transaction} <- Purchases.start_transaction() do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/transactions/#{transaction}")
      |> render(:show, transaction: transaction)
    end
  end

  def process(conn, %{"id" => id, "products" => transaction_products_params}) do
    case Purchases.init_processors(id, transaction_products_params) do
      {:ok, transaction} ->
        conn
        |> put_status(:ok)
        |> put_resp_header("location", ~p"/api/transactions/#{id}")
        |> render(:show, transaction: transaction)

      {:error, :already_processed} ->
        conn
        |> put_status(:precondition_failed)
        |> put_view(PocPurchaseWeb.ErrorJSON)
        |> render("412.json", %{error: "Transaction has already been processed"})
    end
  end
end
