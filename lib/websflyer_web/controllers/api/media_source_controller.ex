defmodule WebsflyerWeb.API.MediaSourceController do
  use WebsflyerWeb, :controller

  alias Websflyer.Affiliates
  alias Affiliates.{MediaSources}
  alias Websflyer.Affiliates.Schemas.MediaSource

  action_fallback WebsflyerWeb.FallbackController

  def index(conn, _params) do
    media_sources = MediaSources.list_media_sources()
    render(conn, "index.json", media_sources: media_sources)
  end

  def create(conn, %{"media_source" => media_source_params}) do
    with {:ok, %MediaSource{} = media_source} <-
           MediaSources.create_media_source(media_source_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_media_source_path(conn, :show, media_source))
      |> render("show.json", media_source: media_source)
    end
  end

  def show(conn, %{"id" => id}) do
    media_source = MediaSources.get_media_source!(id)
    render(conn, "show.json", media_source: media_source)
  end

  def update(conn, %{"id" => id, "media_source" => media_source_params}) do
    media_source = MediaSources.get_media_source!(id)

    with {:ok, %MediaSource{} = media_source} <-
           MediaSources.update_media_source(media_source, media_source_params) do
      render(conn, "show.json", media_source: media_source)
    end
  end

  def delete(conn, %{"id" => id}) do
    media_source = MediaSources.get_media_source!(id)

    with {:ok, %MediaSource{}} <- MediaSources.delete_media_source(media_source) do
      send_resp(conn, :no_content, "")
    end
  end
end
