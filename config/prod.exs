# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :connectum,
  username: System.get_env("CONNECTUM_USERNAME"),
  password: System.get_env("CONNECTUM_PASSWORD"),
  certfile: System.get_env("CONNECTUM_CERTFILE"),
  keyfile: System.get_env("CONNECTUM_KEYFILE")
