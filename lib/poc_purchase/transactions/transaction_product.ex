defmodule PocPurchase.Transactions.TransactionProduct do
  use Ecto.Schema
  import Ecto.Changeset

  alias PocPurchase.Products.Product
  alias PocPurchase.Transactions.Transaction

  schema "transaction_products" do
    field :quantity, :integer
    field :thirdparty_id, :string

    belongs_to :transaction, Transaction
    belongs_to :product, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction_item, attrs) do
    transaction_item
    |> cast(attrs, [:quantity, :thirdparty_id, :product_id])
    |> validate_required([:quantity, :thirdparty_id])
    |> foreign_key_constraint(:product_id)
  end
end
