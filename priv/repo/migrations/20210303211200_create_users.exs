defmodule EventApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :photo_hash, :text

      timestamps()
    end

    create unique_index(:users, [:name])

  end
end
