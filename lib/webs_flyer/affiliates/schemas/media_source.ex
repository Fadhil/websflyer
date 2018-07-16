defmodule WebsFlyer.Affiliates.Schemas.MediaSource do
  use Ecto.Schema
  import Ecto.Changeset


  schema "media_sources" do
    field :aff_name, :string
    field :attribution_window_in_seconds, :integer
    field :do_postback, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @all_attrs [:name, :aff_name, :attribution_window_in_seconds, :do_postback]
  @required_attrs [:aff_name]

  @doc false
  def changeset(media_source, attrs) do
    media_source
    |> cast(attrs, @all_attrs)
    |> validate_required(@required_attrs)
  end
end
