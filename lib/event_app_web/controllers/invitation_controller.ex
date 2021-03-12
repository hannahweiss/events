defmodule EventAppWeb.InvitationController do
  use EventAppWeb, :controller

  alias EventApp.Invitations
  alias EventApp.Invitations.Invitation
  alias EventApp.Repo

  alias EventApp.Users.User

  def index(conn, _params) do
    invitations = Invitations.list_invitations()
    render(conn, "index.html", invitations: invitations)
  end

  def new(conn, _params) do
    changeset = Invitations.change_invitation(%Invitation{})
    render(conn, "new.html", changeset: changeset)
  end

  def format_invite(invite) do
    name = (invite["user_id"])
    user = Repo.get_by(User, name: name)
    IO.inspect(user)
    if (user != nil) and 
    name do
      %{"event_id" => invite["event_id"], "user_id" => Map.get(user, :id), "status" => "No Response"}
    else
      invite
    end
  end

  def create(conn, %{"invitation" => invitation_params}) do
    IO.inspect(invitation_params)
    invitation_params = format_invite(invitation_params)
    case Invitations.create_invitation(invitation_params) do
      {:ok, invitation} ->
        conn
        |> put_flash(:info, "Invitation created successfully.")
        |> redirect(to: Routes.invitation_path(conn, :show, invitation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    invitation = Invitations.get_invitation!(id)
    render(conn, "show.html", invitation: invitation)
  end

  def edit(conn, %{"id" => id}) do
    invitation = Invitations.get_invitation!(id)
    changeset = Invitations.change_invitation(invitation)
    render(conn, "edit.html", invitation: invitation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invitation" => invitation_params}) do
    invitation = Invitations.get_invitation!(id)

    case Invitations.update_invitation(invitation, invitation_params) do
      {:ok, invitation} ->
        conn
        |> put_flash(:info, "Invitation updated successfully.")
        |> redirect(to: Routes.invitation_path(conn, :show, invitation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invitation: invitation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invitation = Invitations.get_invitation!(id)
    {:ok, _invitation} = Invitations.delete_invitation(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: Routes.invitation_path(conn, :index))
  end
end
