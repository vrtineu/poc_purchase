# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PocPurchase.Repo.insert!(%PocPurchase.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PocPurchase.Products.Product
alias PocPurchase.Repo

for i <- 1..10 do
  product = %Product{
    name: "Product #{i}",
    price: i * 10,
    thirdparty_id: "3rd123#{i}"
  }

  Repo.insert!(product)
  IO.puts("Inserted product: #{product.name}")
end
