defmodule Rumbl.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:categories, [:name])

    alter table(:videos) do
      add :category_id, references(:categories)
    end

  end

end
