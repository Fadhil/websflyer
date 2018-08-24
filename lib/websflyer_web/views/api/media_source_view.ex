defmodule WebsflyerWeb.API.MediaSourceView do
  use WebsflyerWeb, :view
  alias WebsflyerWeb.API.MediaSourceView

  def render("index.json", %{media_sources: media_sources}) do
    %{data: render_many(media_sources, MediaSourceView, "media_source.json")}
  end

  def render("show.json", %{media_source: media_source}) do
    %{data: render_one(media_source, MediaSourceView, "media_source.json")}
  end

  def render("media_source.json", %{media_source: media_source}) do
    %{
      id: media_source.id,
      name: media_source.name,
      aff_name: media_source.aff_name,
      attribution_window_in_seconds: media_source.attribution_window_in_seconds,
      do_postback: media_source.do_postback
    }
  end
end
