defmodule Emomon.RoomChannel do
  use Emomon.Web, :channel
  require Logger
  alias Logger, as: L
  alias Emomon.Emostore, as: E

  @inf true
  @dbg false
  
  def join("room:emo", data, sock) do
    user = UUID.uuid4(:hex)
    sock = assign(sock, :user, user)
    if @inf, do: L.debug "JOIN: #{sock.topic} USER: #{user}"
    if @inf, do: L.debug inspect data
    if @dbg, do: L.debug inspect sock
    {:ok, sock}
  end

  # default for all matches -> probably someone tempering JS vars
  def join(_, data, sock) do
    if @inf, do: L.debug "*** ALERT! *** JOIN: #{sock.topic}"
    if @inf, do: L.debug inspect data
    if @dbg, do: L.debug inspect sock
    {:error, %{"msg" => "SORRY, NO ROOM #{sock.topic} AVAILABLE!"}}
  end

  # new emo value via slider input
  def handle_in(e = "emo_val", %{"item" => item, "emov" => emov}, sock)
    when is_integer(item) and is_integer(emov)
    and (item >= 1) and (item <= 1000) and (emov <= 1000) do
    user = sock.assigns.user 
    data = E.put_emo(item, user, emov)
    broadcast sock, "emo_val", data
    if @inf, do: L.debug "t: #{sock.topic} e: #{e} i: #{item} u: #{user}"
    if @inf, do: L.debug inspect data
    if @dbg, do: L.debug inspect sock
    {:noreply, sock}
  end

  # new item value via button
  def handle_in(e = "new_itm", %{"item" => item}, sock)
    when is_integer(item) and (item >= 1) and (item <= 1000) do
    user = sock.assigns.user
    data = E.get_item_data(item, user)
    push sock, "new_itm", data
    if @inf, do: L.debug "t: #{sock.topic} e: #{e} i: #{item} u: #{user}"
    if @inf, do: L.debug inspect data
    if @dbg, do: L.debug inspect sock
    {:noreply, sock}
  end

  # default for all matches -> probably someone tempering JS vars
  def handle_in(e = _, data, sock) do
    if @inf, do: L.debug "t: #{sock.topic} e: #{e} *** ALERT! ***"
    if @inf, do: L.debug inspect data
    if @dbg, do: L.debug inspect sock
    push sock, e, %{"msg" => "Dear Friend, please do not do that, go on and have a nice day!"}
    {:noreply, sock}
  end

end
