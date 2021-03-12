defmodule EventApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :photo_hash, :string
    has_many :events, EventApp.Events.Event, on_delete: :delete_all
    has_many :invitations, EventApp.Invitations.Invitation, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :photo_hash])
    |> unique_constraint(:name)
    |> validate_required([:name, :email])
  end
end
