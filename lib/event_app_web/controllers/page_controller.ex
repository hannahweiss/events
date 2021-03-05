defmodule EventAppWeb.PageController do
  use EventAppWeb, :controller

  def index(conn, _params) do
    events = EventApp.Events.list_events()
    render(conn, "index.html", events: events)
  end
end
