defmodule EventApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    has_many :events, EventApp.Events.Event
    has_many :invitations, EventApp.Invitations.Invitation

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> unique_constraint(:name)
    |> validate_required([:name, :email])
  end
end
