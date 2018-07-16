defmodule WebsFlyer.Repo.Migrations.CreateUserAttributions do
  use Ecto.Migration

  def change do
    create table(:user_attributions) do
      add :user_cookie, :string
      add :user_id, :integer
      add :attributed_to, :string
      add :attribution_start_timestamp, :integer
      add :attribution_window_in_seconds, :integer

      timestamps()
    end

  end
end
