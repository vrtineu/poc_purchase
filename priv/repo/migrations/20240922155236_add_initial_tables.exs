defmodule PocPurchase.Repo.Migrations.AddInitialTables do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :status, :string

      timestamps(type: :utc_datetime)
    end

    create table(:products) do
      add :name, :string
      add :price, :decimal
      add :thirdparty_id, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:transaction_products) do
      add :quantity, :integer
      add :thirdparty_id, :string, null: false
      add :transaction_id, references(:transactions)

      timestamps(type: :utc_datetime)
    end

    create table(:orders) do
      add :total_amount, :decimal
      add :status, :string
      add :transaction_id, references(:transactions)

      timestamps(type: :utc_datetime)
    end

    create index(:orders, [:transaction_id])
    create index(:transaction_products, [:transaction_id])
    create index(:transaction_products, [:thirdparty_id])
    create unique_index(:products, [:thirdparty_id])
  end
end
