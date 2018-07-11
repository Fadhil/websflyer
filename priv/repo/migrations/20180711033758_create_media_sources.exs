defmodule WebsFlyer.Repo.Migrations.CreateMediaSources do
  use Ecto.Migration

  def change do
    create table(:media_sources) do
      add :name, :string
      add :aff_name, :string
      add :attribution_window_in_seconds, :integer
      add :do_postback, :boolean, default: false, null: false

      timestamps()
    end

  end
end
