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

  @required_attrs [:event]
  @click_required_attrs [:event, :url_params, :user_cookie]

  defguard is_valid?(string) when not is_nil(string) and byte_size(string) > 0

  def changeset(attribution, attrs) do
    attribution
    |> cast(attrs, [:url_params, :aff_name, :event, :user_cookie, :user_id, :rs_id, :status, :transaction_id, :s2s_post_params])
    |> validate_required(@required_attrs)
  end

  def click_changeset(attribution, attrs) do
    changeset(attribution, attrs)
    |> validate_required(@click_required_attrs)
    |> put_click_attribution_details()
  end

  def put_click_attribution_details(%Ecto.Changeset{valid?: true, changes: %{url_params: url_params}} = changeset) do
    changeset
    |> put_change(:aff_name, get_affiliate_name(url_params))
  end

  def put_click_attribution_details(changeset) do
    changeset
  end

  def get_affiliate_name(params_string) do
    params = 
      params_string
      |> String.trim_leading("?")
      |> URI.decode_query()

    case params do
      %{"utm_source" => affiliate_name} ->
        affiliate_name
      _ ->
        "unknown"
    end
  end
end
