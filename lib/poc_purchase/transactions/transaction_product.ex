defmodule PocPurchase.Transactions.TransactionProduct do
  use Ecto.Schema
  import Ecto.Changeset

  alias PocPurchase.Transactions.Transaction

  schema "transaction_products" do
    field :quantity, :integer
    field :thirdparty_id, :string

    belongs_to :transaction, Transaction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction_item, attrs) do
    transaction_item
    |> cast(attrs, [:quantity, :thirdparty_id])
    |> validate_required([:quantity, :thirdparty_id])
  end
end
