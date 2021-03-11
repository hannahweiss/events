defmodule EventApp.Invitations.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invitations" do
    field :status, :string
    belongs_to :event, EventApp.Events.Event
    belongs_to :user, EventApp.Users.User

    timestamps()
  end

  # def format_invite(invite) do
  #   IO.inspect(invite)
  #   if Map.has_key?(invite, "user_id") do
  #     user = EventApp.Users.get_user_by_name(invite["user_id"])
  #     if user do
  #       %{"event_id" => invite["event_id"], "user_id" => user["id"], "status" => "No Response"}
  #     else
  #       invite
  #     end
  #   else
  #     invite
  #   end
  # end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:status, :event_id, :user_id])
    |> validate_required([:status, :event_id, :user_id])
  end
end
