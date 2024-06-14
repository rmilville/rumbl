defmodule InfoSys.Test.HTTPClient do
  @wolfram_xml File.read!("test/fixtures/wolfram.xml")

  def request(url) do
    url = to_string(url)
    cond do
      String.contains?(url, "what+is+elixir") ->
        {:ok, {200, [], @wolfram_xml}}
      String.contains?(url, "error") ->
        {:error}
      true ->
        {:ok, {[], [], "<queryresult></queryresult>"}}
    end
  end
end
