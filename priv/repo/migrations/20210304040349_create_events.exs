defmodule EventApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :text
      add :date, :date
      add :description, :text

      timestamps()
    end

  end
end
