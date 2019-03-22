defmodule Connectum do
  @moduledoc """
  Library for payment services Connectum
  """

  @order_expand [
    "card",
    "client",
    "location",
    "custom_fields",
    "issuer",
    "secure3d",
    "operations.cashflow"
  ]

  def order_expand_information(expand) when is_list(expand) do
    case expand do
      [] ->
        {:ok, ""}

      expand ->
        # credo:disable-for-next-line Credo.Check.Refactor.Nesting
        if Enum.all?(expand, fn item -> Enum.member?(@order_expand, item) end) do
          {:ok, "expand=" <> Enum.join(expand, ",")}
        else
          {:error, %{reason: "Invalid expand"}}
        end
    end
  end
end
