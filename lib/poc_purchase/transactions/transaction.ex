defmodule PocPurchase.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias PocPurchase.Orders.Order
  alias PocPurchase.Transactions.{Transaction, TransactionProduct}

  schema "transactions" do
    field :status, Ecto.Enum, values: [:active, :pending, :processed]

    has_many :transaction_products, TransactionProduct
    has_one :order, Order

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> cast_assoc(:transaction_products, with: &TransactionProduct.changeset/2)
  end
end
