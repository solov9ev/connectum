# Connectum

**Connectum API client**

## Installation

The package can be installed by adding `connectum` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:connectum, git: "git@github.com:solov9ev/connectum.git"}
  ]
end
```

## Certificates

For the start should be generated the `certificates`:

```bash
openssl pkcs12 -in certificate.p12 -out private.key -nocerts -nodes
openssl pkcs12 -in certificate.p12 -out certificate.cer -nokeys
```

## Create authorize an order
```elixir
response = Connectum.Client.authorize %{
  "amount" => 1.0,
  "pan" => 4111111111111111,
  "card" => %{
    "cvv" => 123,
    "holder" => "John Smith",
    "expiration_month" => "06",
    "expiration_year" => "2022"
  },
  "location" => %{
    "ip" => "8.8.8.8"
  },
  "currency" => "USD",
  "merchant_order_id" => 1,
  "segment" => 987654321,
  "description" => "Book sale #453",
  "client" => %{
    "address" => "Main ave. 1",
    "city" => "San Francisco",
    "country" => "USA",
    "login" => "john_doe",
    "email" => "foo@bar.com",
    "name" => "John Smith",
    "phone" => "+1 456 890",
    "state" => "CA",
    "zip" => "123456",
    "option" => %{
      "force3d" => 1,
      "auto_charge" => 1,
      "terminal" => "TERM12",
      "recurring" => 1
    }
  },
  "options" => %{
    "auto_charge" => 1
  }
}
```

