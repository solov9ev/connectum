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

