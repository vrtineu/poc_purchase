defmodule PocPurchase.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias PocPurchase.Transactions.Transaction

  schema "orders " do
    field :total_amount, :decimal
    field :status, Ecto.Enum, values: [:rejected, :paid, :pending]

    belongs_to :transaction, Transaction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:total_amount, :status, :transaction_id])
    |> validate_required([:total_amount, :status, :transaction_id])
  end
end
