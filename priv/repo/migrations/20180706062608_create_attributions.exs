defmodule Websflyer.Repo.Migrations.CreateAttributions do
  use Ecto.Migration

  def change do
    create table(:attributions) do
      add :url_params, :string
      add :aff_name, :string
      add :event, :string
      add :user_cookie, :string
      add :user_id, :integer
      add :rs_id, :integer
      add :status, :string
      add :transaction_id, :string
      add :s2s_post_params, :string

      timestamps()
    end

  end
end
