defmodule PocPurchase.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias PocPurchase.Products.Product

  schema "products" do
    field :name, :string
    field :price, :decimal
    field :thirdparty_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:name, :price, :thirdparty_id])
    |> validate_required([:name, :price, :thirdparty_id])
    |> unique_constraint(:thirdparty_id)
  end
end
