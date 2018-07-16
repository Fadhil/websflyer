defmodule WebsFlyerWeb.API.AttributionController do
  use WebsFlyerWeb, :controller

  alias WebsFlyer.Affiliates.{Attributions}
  alias WebsFlyer.Affiliates.Schemas.Attribution

  action_fallback WebsFlyerWeb.FallbackController

  def index(conn, _params) do
    attributions = Attributions.list_attributions()
    render(conn, "index.json", attributions: attributions)
  end

  def create(conn, %{"attribution" => attribution_params}) do
    with {:ok, %Attribution{} = attribution} <- Attributions.create_attribution(attribution_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_attribution_path(conn, :show, attribution))
      |> render("show.json", attribution: attribution)
    end
  end

  def show(conn, %{"id" => id}) do
    attribution = Attributions.get_attribution!(id)
    render(conn, "show.json", attribution: attribution)
  end

  def update(conn, %{"id" => id, "attribution" => attribution_params}) do
    attribution = Attributions.get_attribution!(id)

    with {:ok, %Attribution{} = attribution} <- Attributions.update_attribution(attribution, attribution_params) do
      render(conn, "show.json", attribution: attribution)
    end
  end

  def delete(conn, %{"id" => id}) do
    attribution = Attributions.get_attribution!(id)
    with {:ok, %Attribution{}} <- Attributions.delete_attribution(attribution) do
      send_resp(conn, :no_content, "")
    end
  end
end
