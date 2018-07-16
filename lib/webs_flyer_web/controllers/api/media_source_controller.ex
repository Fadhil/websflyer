defmodule WebsFlyerWeb.API.MediaSourceController do
  use WebsFlyerWeb, :controller

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Schemas.MediaSource

  action_fallback WebsFlyerWeb.FallbackController

  def index(conn, _params) do
    media_sources = Affiliates.list_media_sources()
    render(conn, "index.json", media_sources: media_sources)
  end

  def create(conn, %{"media_source" => media_source_params}) do
    with {:ok, %MediaSource{} = media_source} <- Affiliates.create_media_source(media_source_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_media_source_path(conn, :show, media_source))
      |> render("show.json", media_source: media_source)
    end
  end

  def show(conn, %{"id" => id}) do
    media_source = Affiliates.get_media_source!(id)
    render(conn, "show.json", media_source: media_source)
  end

  def update(conn, %{"id" => id, "media_source" => media_source_params}) do
    media_source = Affiliates.get_media_source!(id)

    with {:ok, %MediaSource{} = media_source} <- Affiliates.update_media_source(media_source, media_source_params) do
      render(conn, "show.json", media_source: media_source)
    end
  end

  def delete(conn, %{"id" => id}) do
    media_source = Affiliates.get_media_source!(id)
    with {:ok, %MediaSource{}} <- Affiliates.delete_media_source(media_source) do
      send_resp(conn, :no_content, "")
    end
  end
end
