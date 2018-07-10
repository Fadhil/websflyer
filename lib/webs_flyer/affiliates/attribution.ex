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

  @required_attrs [:user_cookie]

  @doc false
  def changeset(attribution, attrs) do
    attribution
    |> cast(attrs, [:url_params, :aff_name, :event, :user_cookie, :user_id, :rs_id, :status, :transaction_id, :s2s_post_params])
    |> validate_required(@required_attrs)
    |> put_attribution_details()
  end

  def put_attribution_details(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{url_params: url_params}} 
          when not is_nil(url_params) and byte_size(url_params) > 0 ->
        put_click_data(changeset, url_params)
      %Ecto.Changeset{valid?: true, changes: %{user_id: user_id}} 
          when not is_nil(user_id) ->
        changeset
      _ ->
        changeset
    end
  end

  def put_click_data(changeset, url_params) do
    changeset
    |> put_change(:aff_name, get_affiliate_name(url_params))
    |> put_change(:event, "click")
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
