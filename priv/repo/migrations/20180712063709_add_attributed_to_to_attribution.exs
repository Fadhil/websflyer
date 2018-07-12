defmodule WebsFlyer.Repo.Migrations.AddAttributedToToAttribution do
  use Ecto.Migration

  def change do
    alter table(:attributions) do
      add :attributed_to, :string
    end
  end
end
