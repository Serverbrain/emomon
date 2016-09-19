defmodule Emomon.PageController do
  use Emomon.Web, :controller

  def index(conn, _params) do
    conn = put_session(conn, :message, "YUID")
    render conn, "index.html"
  end
end
