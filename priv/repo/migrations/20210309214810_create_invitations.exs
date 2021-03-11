defmodule EventApp.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :status, :text, null: false, default: "no response"
      add :event_id, references(:events, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:invitations, [:event_id])
    create index(:invitations, [:user_id])
  end
end
