defmodule EventApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :text
      add :date, :date
      add :description, :text
      add :user_id, references(:users, on_delete: :cascade), null: false

      timestamps()
    end

  end
end
