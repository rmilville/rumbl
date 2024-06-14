defmodule InfoSys.Wolfram do
  import SweetXml
  alias InfoSys.Result

  @behaviour InfoSys.Backend

  @base "http://api.wolframalpha.com/v2/query"

  @impl true
  def name, do: "Wolfram"

  @http Application.compile_env(:info_sys, :wolfram)[:http_client] || :httpc
# defp fetch_xml(query) do
#    {:ok, {_, _, body}} = @http.request(String.to_charlist(url(query)))
#
#    body
#  end
  defp fetch_xml(query) do
    url(query)
    |> String.to_charlist()
    |> @http.request()
    |> handle_response()
  end

  @impl true
  def compute(querystr, _opts) do
    querystr
    |> fetch_xml()
    |> parse_xml()
    |> build_results()
  end

  defp parse_xml({:ok, body}) do
    xpath(body, ~x"/queryresult/pod[contains(@title, 'Result') or contains(@title, 'Definition')]/subpod/plaintext/text()"s)
  rescue
    _ -> nil
  end

  defp parse_xml({:error, _} = error), do: error

  defp build_results(nil), do: []

  defp build_results(answer) when is_binary(answer) do
    [%Result{backend: __MODULE__, score: 95, text: answer}]
  end

  defp build_results(_), do: []

  defp handle_response({:ok, {_, _, body}}) do
    {:ok, body}
  rescue
    _ -> {:error, :invalid_response}
  end

  defp handle_response(_), do: {:error, :request_failed}

  defp url(input) do
    "#{@base}?" <> URI.encode_query(appid: apikey(), input: input)
  end

  defp apikey(), do: Application.get_env(:info_sys, :wolfram_app_id)
end
