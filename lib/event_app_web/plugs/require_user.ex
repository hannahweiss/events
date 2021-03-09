# attribution: https://github.com/NatTuck/scratch-2021-01/blob/master/notes-4550/13-access-rules/notes.md

defmodule EventAppWeb.Plugs.RequireUser do
    use EventAppWeb, :controller
  
    def init(args), do: args
  
    def call(conn, _args) do
      if conn.assigns[:current_user] do
        conn
      else
        conn
        |> put_flash(:error, "You must log in to do that.")
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()
      end
    end
  end