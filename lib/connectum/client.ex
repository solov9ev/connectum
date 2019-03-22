defmodule Connectum.Client do
  @moduledoc false

  def ping(), do: get("/ping")

  def order_information(id), do: get("/orders/#{id}")

  # Private functions --------------------------------------------------------------------------------------------------

  defp get(endpoint, headers \\ [], options \\ []) do
    endpoint
    |> build_url()
    |> HTTPoison.get(prepare_headers(headers), prepare_options(options))
    |> handle_request()
  end

  defp handle_request(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}}
      when status_code in [200, 201] ->
        parse_response_body(body)

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {_, prepared_body} = parse_response_body(body)
        {:error, %{status_code: status_code, body: prepared_body}}

      {:error, error} ->
        {:error, error}
    end
  end

  defp parse_response_body(body) do
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
