defmodule InfoSys.Cache do
  use GenServer

  @clear_internal :timer.seconds(60)

  def put(name \\ __MODULE__, key, value) do
    true = :ets.insert(tab_name(name), {key, value})
    :ok
  end

  def fetch(name \\ __MODULE__, key) do
    result = :ets.lookup_element(tab_name(name), key, 2)
    {:ok, result}
  rescue
    ArgumentError -> :error
  end

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  def init(opts) do
    state = %{
      interval: opts[:interval] || @clear_internal,
      timer: nil,
      table: new_table(opts[:name])
    }
    {:ok, schedule_clear(state)}
  end

  def handle_info(:clear, state) do
    :ets.delete_all_objects(state.table)
    {:noreply, schedule_clear(state)}
  end

  defp schedule_clear(state) do
    %{state | timer: Process.send_after(self(), :clear, state.interval)}
  end

  defp new_table(name) do
    tab_name = tab_name(name)
    :ets.new(tab_name, [
      :set,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])
    tab_name
  end

  defp tab_name(name), do: :"#{name}_cache"
end
