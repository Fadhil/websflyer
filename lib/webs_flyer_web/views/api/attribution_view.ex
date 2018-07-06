defmodule WebsFlyerWeb.API.AttributionView do
  use WebsFlyerWeb, :view
  alias WebsFlyerWeb.API.AttributionView

  def render("index.json", %{attributions: attributions}) do
    %{data: render_many(attributions, AttributionView, "attribution.json")}
  end

  def render("show.json", %{attribution: attribution}) do
    %{data: render_one(attribution, AttributionView, "attribution.json")}
  end

  def render("attribution.json", %{attribution: attribution}) do
    %{id: attribution.id,
      url_params: attribution.url_params,
      aff_name: attribution.aff_name,
      event: attribution.event,
      user_cookie: attribution.user_cookie,
      user_id: attribution.user_id,
      rs_id: attribution.rs_id,
      status: attribution.status,
      transaction_id: attribution.transaction_id,
      s2s_post_params: attribution.s2s_post_params}
  end
end
