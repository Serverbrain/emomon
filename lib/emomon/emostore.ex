defmodule Emomon.Emostore do
  @moduledoc """
  Store Emotions about Items
  %{ item_id => %{user_id => emo_val} }
  https://dockyard.com/blog/2016/02/01/elixir-best-practices-deeply-nested-maps
  """
  use GenServer
  require Logger
  alias Logger, as: L

  @inf true
  @dbg false
  @filestore Path.join(["priv/", "store.bin"])

  # ------------------------------------------------------------------
  # Client API
  # ------------------------------------------------------------------

  def start_link() do
    if @inf, do: L.debug "STARTING EMOSTORE!"
    GenServer.start_link(__MODULE__, :ok, [{:name, __MODULE__}])
  end

  # put new %{ item_id => %{user_id => emo_val} }
  def put_emo(item_id, user_id, emo_val) do
    GenServer.call(__MODULE__, {:put_emo, item_id, user_id, emo_val})
  end

  def get_item_data(item_id, user_id) do
    GenServer.call(__MODULE__, {:get_item_data, item_id, user_id})
  end

  # get emo value for user and item
  def get_emo(item_id, user_id) do
    GenServer.call(__MODULE__, {:get_emo, item_id, user_id})
  end

  # count of emo values for item
  def get_emo_count(item_id) do
    GenServer.call(__MODULE__, {:get_emo_count, item_id})
  end

  # max emo value
  def get_emo_max(item_id) do
    GenServer.call(__MODULE__, {:get_emo_max, item_id})
  end

  # min emo value
  def get_emo_min(item_id) do
    GenServer.call(__MODULE__, {:get_emo_min, item_id})
  end
  
  # average emo value
  def get_emo_avg(item_id) do
    GenServer.call(__MODULE__, {:get_emo_avg, item_id})
  end

  # ------------------------------------------------------------------
  # Server Callbacks
  # ------------------------------------------------------------------

  def init(_) do
    Process.send_after(self, :store_report, 60000)
    Process.send_after(self, :store_save, 600000)
    store = 
    if File.exists?(@filestore) do
      File.read!(@filestore) |> :erlang.binary_to_term
      else %{}
    end
    {:ok, store}
  end

  def handle_call({:put_emo, item_id, user_id, emo_val}, _from, store) do
    store = 
    if Map.has_key?(store, item_id) do
      store_new = store |> Map.get(item_id) |> Map.put(user_id, emo_val)
      Map.put(store, item_id, store_new)
    else
      Map.put(store, item_id, %{user_id => emo_val})
    end
    {:reply, get_item_data_impl(item_id, user_id, store), store}
  end

  def handle_call({:get_item_data, item_id, user_id}, _from, store) do
    data = get_item_data_impl(item_id, user_id, store)
    {:reply, data, store}
  end

  def handle_call({:get_emo, item_id, user_id}, _from, store) do
    data = get_emo_impl(item_id, user_id, store)
    {:reply, data, store}
  end

  def handle_call({:get_emo_count, item_id}, _from, store) do
    data = get_emo_count_impl(item_id, store)
    {:reply, data, store}
  end

  def handle_call({:get_emo_max, item_id}, _from, store) do
    data = get_emo_max_impl(item_id, store)
    {:reply, data, store}
  end

  def handle_call({:get_emo_min, item_id}, _from, store) do
    data = get_emo_min_impl(item_id, store)
    {:reply, data, store}
  end

  def handle_call({:get_emo_avg, item_id}, _from, store) do
    data = get_emo_avg_impl(item_id, store)
    {:reply, data, store}
  end

  def handle_info(:store_save, store) do
    if @inf, do: L.debug "STORE SAVE RUN - WRITING TO #{@filestore}"
    File.write! @filestore, :erlang.term_to_binary(store)
    Process.send_after(self, :store_save, 600000)
    {:noreply, store}    
  end

  def handle_info(:store_report, store) do
    L.debug ""
    L.debug "+ STORE REPORT ------------- +"
    L.debug "| ID | CNT | MIN | MAX | AVG |"
    L.debug "| -- | --- | --- | --- | --- |"
    
    cnt = store |> Map.values |> Enum.count
    if cnt > 0 do
      Enum.each(store, fn { item_id, item_map} ->
        cnt = item_map |> Map.values |> Enum.count
        sum = item_map |> Map.values |> Enum.sum
        min = item_map |> Map.values |> Enum.min |> sf(3)
        max = item_map |> Map.values |> Enum.max |> sf(3)
        avg = sum / cnt
        avg = avg |> round |> sf(3)
        L.debug "| #{sf(item_id,2)} | #{sf(cnt,3)} | #{min} | #{max} | #{avg} |"
      end
      )
    end
    L.debug "| -------------------------- |"
    L.debug "| ITEMS COUNT: #{sf(cnt,3)} --------- |"
    L.debug "+ STORE REPORT END --------- +"
    L.debug ""
    Process.send_after(self, :store_report, 60000)
    {:noreply, store}
  end

  # ------------------------------------------------------------------
  # Feature Implementation
  # ------------------------------------------------------------------

  defp get_emo_impl(item_id, user_id, store) do
    if Map.has_key?(store, item_id) do
      get_in(store, [item_id, user_id])
    end
  end

  defp get_item_data_impl(item_id, user_id, store) do
    if Map.has_key?(store, item_id) do
      emo_usr = get_emo_impl(item_id, user_id, store)
      emo_cnt = get_emo_count_impl(item_id, store)
      emo_avg = round(get_emo_avg_impl(item_id, store))
      emo_min = get_emo_min_impl(item_id, store)
      emo_max = get_emo_max_impl(item_id, store)
      %{ "itm" => item_id, "cnt" => emo_cnt, "max" => emo_max,
         "min" => emo_min, "avg" => emo_avg, "usr" => emo_usr }
    else
      %{ "itm" => item_id, "cnt" => 0, "max" => 0,
         "min" => 0, "avg" => 0, "usr" => nil }
    end
  end

  defp get_emo_count_impl(item_id, store) do
    store |> Map.get(item_id, %{}) |> Map.values |> Enum.count
  end

  defp get_emo_max_impl(item_id, store) do
    store |> Map.get(item_id, %{x: 0}) |> Map.values |> Enum.max
  end

  defp get_emo_min_impl(item_id, store) do
    store |> Map.get(item_id, %{x: 0}) |> Map.values |> Enum.min
  end

  defp get_emo_avg_impl(item_id, store) do
    if Map.has_key?(store, item_id) do
      emo_cnt = store |> Map.get(item_id) |> Map.values |> Enum.count
      emo_sum = store |> Map.get(item_id, %{}) |> Map.values |> Enum.sum
      emo_sum / emo_cnt
    end
  end

  # helper
  defp sf(number, zeros) do
    number |> Integer.to_string |> String.rjust(zeros, ?0)
  end
  
end
