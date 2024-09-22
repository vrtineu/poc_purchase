defmodule PocPurchase.Repo do
  use Ecto.Repo,
    otp_app: :poc_purchase,
    adapter: Ecto.Adapters.Postgres
end
