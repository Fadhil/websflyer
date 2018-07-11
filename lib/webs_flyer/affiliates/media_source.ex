defmodule WebsFlyer.Affiliates.MediaSource do
  use Ecto.Schema
  import Ecto.Changeset


  schema "media_sources" do
    field :aff_name, :string
    field :attribution_window_in_seconds, :integer
    field :do_postback, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(media_source, attrs) do
    media_source
    |> cast(attrs, [:name, :aff_name, :attribution_window_in_seconds, :do_postback])
    |> validate_required([:name, :aff_name, :attribution_window_in_seconds, :do_postback])
  end
end
