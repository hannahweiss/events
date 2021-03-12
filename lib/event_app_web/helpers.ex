alias EventApp.Repo
alias EventApp.Events.Event
alias EventApp.Invitations.Invitation

defmodule EventAppWeb.Helpers do
    def have_current_user?(conn) do
        conn.assigns[:current_user] != nil
    end

    def current_user_id?(conn, user_id) do
        user = conn.assigns[:current_user]
        user && user.id == user_id
    end

    def current_user_id(conn) do
        user = conn.assigns[:current_user]
        user && user.id
    end

    def get_invite_id(conn, event_id) do
        user_id = conn.assigns[:current_user].id

        event = Repo.get_by(Invitation, [user_id: user_id, event_id: event_id])
    end
end