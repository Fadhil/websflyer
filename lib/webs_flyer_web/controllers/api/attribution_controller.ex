defmodule WebsFlyerWeb.API.AttributionController do
  use WebsFlyerWeb, :controller

  alias WebsFlyer.Affiliates
  alias WebsFlyer.Affiliates.Attribution

  action_fallback WebsFlyerWeb.FallbackController

  def index(conn, _params) do
    attributions = Affiliates.list_attributions()
    render(conn, "index.json", attributions: attributions)
  end

  def create(conn, %{"attribution" => attribution_params}) do
    with {:ok, %Attribution{} = attribution} <- Affiliates.create_attribution(attribution_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_attribution_path(conn, :show, attribution))
      |> render("show.json", attribution: attribution)
    end
  end

  def show(conn, %{"id" => id}) do
    attribution = Affiliates.get_attribution!(id)
    render(conn, "show.json", attribution: attribution)
  end

  def update(conn, %{"id" => id, "attribution" => attribution_params}) do
    attribution = Affiliates.get_attribution!(id)

    with {:ok, %Attribution{} = attribution} <- Affiliates.update_attribution(attribution, attribution_params) do
      render(conn, "show.json", attribution: attribution)
    end
  end

  def delete(conn, %{"id" => id}) do
    attribution = Affiliates.get_attribution!(id)
    with {:ok, %Attribution{}} <- Affiliates.delete_attribution(attribution) do
      send_resp(conn, :no_content, "")
    end
  end
end
