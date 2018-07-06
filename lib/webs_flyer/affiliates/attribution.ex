defmodule WebsFlyer.Affiliates.Attribution do
  use Ecto.Schema
  import Ecto.Changeset


  schema "attributions" do
    field :aff_name, :string
    field :event, :string
    field :rs_id, :integer
    field :s2s_post_params, :string
    field :status, :string
    field :transaction_id, :string
    field :url_params, :string
    field :user_cookie, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(attribution, attrs) do
    attribution
    |> cast(attrs, [:url_params, :aff_name, :event, :user_cookie, :user_id, :rs_id, :status, :transaction_id, :s2s_post_params])
    |> validate_required([:url_params, :aff_name, :event, :user_cookie, :user_id, :rs_id, :status, :transaction_id, :s2s_post_params])
  end
end
