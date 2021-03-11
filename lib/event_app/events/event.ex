defmodule EventApp.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :date, :date
    field :description, :string
    field :name, :string
    belongs_to :user, EventApp.Users.User
    has_many :comments, EventApp.Comments.Comment, on_delete: :delete_all
    has_many :invitations, EventApp.Invitations.Invitation, on_delete: :delete_all

    timestamps()
  end

  def convert_date(event) do

    if Map.has_key?(event, "date") do
      IO.inspect(event)

      date_list = String.split(event["date"], " ")

      months = %{
        "Jan" => 1,
        "Feb" => 2,
        "Mar" => 3,
        "Apr" => 4,
        "May" => 5,
        "Jun" => 6,
        "Jul" => 7,
        "Aug" => 8,
        "Sep" => 9,
        "Oct" => 10,
        "Nov" => 11,
        "Dec" => 12
      }

      %{"name" => event["name"], "description" => event["description"], "user_id" => event["user_id"], "date" => %{
        "day" => Enum.at(date_list, 2), "month" => Map.fetch!(months, Enum.at(date_list, 1)), "year" => Enum.at(date_list, 3)
      }}
    else
      event
    end
  end

  @doc false
  def changeset(event, attrs) do
    IO.inspect(attrs)
    event
    |> cast(convert_date(attrs), [:name, :date, :description, :user_id])
    |> validate_required([:name, :date, :description, :user_id])
  end
end
