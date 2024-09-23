# PocPurchase

PocPurchase is a project that simulates a purchase flow through two different routes. The first route will create a new transaction and the second route will give the products and then process the transaction until the order payment. The entire flow works around the GenStage library, allowing us to create a workflow from the beginning of the purchase flow to the end with the order payment.

The goal is to demonstrate that Elixir is sufficient and doesn't require third-party tools in most cases. It does not mean we have to avoid these tools, I'm just showing how Elixir can take this work and handle it nicely and well, so in this example, I'm using GenStage instead of an SQS queue or something like that.

In future versions, I will make this work well in distributed systems, but I need to learn more about it.
