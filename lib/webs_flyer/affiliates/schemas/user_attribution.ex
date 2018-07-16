defmodule WebsFlyer.Affiliates.Schemas.UserAttribution do
  use Ecto.Schema
  import Ecto.Changeset


  schema "user_attributions" do
    field :attributed_to, :string
    field :attribution_start_timestamp, :integer
    field :attribution_window_in_seconds, :integer
    field :user_cookie, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user_attribution, attrs) do
    user_attribution
    |> cast(attrs, [:user_cookie, :user_id, :attributed_to, :attribution_start_timestamp, :attribution_window_in_seconds])
    |> validate_required([:user_cookie, :user_id, :attributed_to, :attribution_start_timestamp, :attribution_window_in_seconds])
  end
end
