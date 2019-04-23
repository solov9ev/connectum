defmodule Connectum.Client do
  @moduledoc """
  This module generates and sends requests.
  """

  # Test request -------------------------------------------------------------------------------------------------------

  def ping, do: get("/ping")

  # Fetching data ------------------------------------------------------------------------------------------------------

  def order_information(id), do: get("/orders/#{id}")

  def order_information(id, params) when is_map(params) do
    get("/orders/#{id}/?expand=#{Enum.join(params, ",")}")
  end

  def list_of_orders(params \\ []) do
    get("/orders/?" <> URI.encode_query(params))
  end

  def list_of_operations(params \\ %{}) do
    get("/operations/?" <> URI.encode_query(params))
  end

  # Working with orders ------------------------------------------------------------------------------------------------

  def order_creation(body) do
    post("/orders/create", Poison.encode!(body))
  end

  def authorize(body) do
    post("/orders/authorize", Poison.encode!(body))
  end

  def repeating_payment(id, body) do
    post("/orders/#{id}/rebill", Poison.encode!(body))
  end

  def original_credit_transaction(id, body) do
    post("/orders/#{id}/credit", Poison.encode!(body))
  end

  def reverse(id), do: put("/orders/#{id}/reverse")

  def charge(id), do: put("/orders/#{id}/charge")

  def charge(id, body) do
    put("/orders/#{id}/charge", Poison.encode!(body))
  end

  def refund(id), do: put("/orders/#{id}/refund")

  def refund(id, body) do
    put("/orders/#{id}/refund", Poison.encode!(body))
  end

  def cancel(id), do: put("/orders/#{id}/cancel")

  def cancel(id, body) do
    put("/orders/#{id}/cancel", Poison.encode!(body))
  end

  # Private functions --------------------------------------------------------------------------------------------------

  defp get(endpoint, headers \\ [], options \\ []) do
    endpoint
    |> build_url()
    |> HTTPoison.get(prepare_headers(headers), prepare_options(options))
    |> handle_request()
  end

  defp post(endpoint, body, headers \\ [], options \\ []) do
    endpoint
    |> build_url()
    |> HTTPoison.post(body, prepare_headers(headers), prepare_options(options))
    |> handle_request()
  end

  defp put(endpoint, body \\ "", headers \\ [], options \\ []) do
    endpoint
    |> build_url()
    |> HTTPoison.put(body, prepare_headers(headers), prepare_options(options))
    |> handle_request()
  end

  defp handle_request(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}}
      when status_code in [200, 201] ->
        decode_body(body)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {_, prepared_body} = decode_body(body)
        {:error, %{status_code: status_code, body: prepared_body}}

      {:error, error} ->
        {:error, error}
    end
  end

  defp decode_body(body) do
    case Poison.decode(body) do
      {:ok, body} ->
        {:ok, body}

      {:error, error} ->
        {:error, error}
    end
  end

  defp build_url(endpoint) do
    "https://api.#{op_mode()}connectum.eu#{endpoint}"
  end

  defp op_mode do
    case Mix.env() do
      :prod -> ""
      _ -> "sandbox."
    end
  end

  defp prepare_headers(headers) when is_list(headers) do
    [
      header_authorization(),
      header_content_type()
    ] ++ headers
  end

  defp header_authorization do
    base64 =
      "#{Application.get_env(:connectum, :username)}:#{Application.get_env(:connectum, :password)}"
      |> Base.encode64()

    {"Authorization", "Basic #{base64}"}
  end

  defp header_content_type, do: {"Content-Type", "application/json"}

  defp prepare_options(options) when is_list(options) do
    option_hackney_ssl() ++ options
  end

  defp option_hackney_ssl do
    [
      hackney: [
        ssl_options: [
          certfile: Application.get_env(:connectum, :certfile),
          keyfile: Application.get_env(:connectum, :keyfile)
        ]
      ]
    ]
  end
end
