defmodule WebsflyerWeb.API.UserAttributionController do
  use WebsflyerWeb, :controller

  alias Websflyer.Affiliates
  alias Websflyer.Affiliates.Schemas.UserAttribution

  action_fallback WebsflyerWeb.FallbackController

  def index(conn, _params) do
    user_attributions = Affiliates.UserAttributions.list_user_attributions()
    render(conn, "index.json", user_attributions: user_attributions)
  end

  def create(conn, %{"user_attribution" => user_attribution_params}) do
    with {:ok, %UserAttribution{} = user_attribution} <-
           Affiliates.UserAttributions.create_user_attribution(user_attribution_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_user_attribution_path(conn, :show, user_attribution))
      |> render("show.json", user_attribution: user_attribution)
    end
  end

  def show(conn, %{"id" => id}) do
    user_attribution = Affiliates.UserAttributions.get_user_attribution!(id)
    render(conn, "show.json", user_attribution: user_attribution)
  end

  def update(conn, %{"id" => id, "user_attribution" => user_attribution_params}) do
    user_attribution = Affiliates.UserAttributions.get_user_attribution!(id)

    with {:ok, %UserAttribution{} = user_attribution} <-
           Affiliates.UserAttributions.update_user_attribution(
             user_attribution,
             user_attribution_params
           ) do
      render(conn, "show.json", user_attribution: user_attribution)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_attribution = Affiliates.UserAttributions.get_user_attribution!(id)

    with {:ok, %UserAttribution{}} <-
           Affiliates.UserAttributions.delete_user_attribution(user_attribution) do
      send_resp(conn, :no_content, "")
    end
  end
end
