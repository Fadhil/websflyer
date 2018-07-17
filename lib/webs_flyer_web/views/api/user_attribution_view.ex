defmodule WebsFlyerWeb.API.UserAttributionView do
  use WebsFlyerWeb, :view
  alias WebsFlyerWeb.API.UserAttributionView

  def render("index.json", %{user_attributions: user_attributions}) do
    %{data: render_many(user_attributions, UserAttributionView, "user_attribution.json")}
  end

  def render("show.json", %{user_attribution: user_attribution}) do
    %{data: render_one(user_attribution, UserAttributionView, "user_attribution.json")}
  end

  def render("user_attribution.json", %{user_attribution: user_attribution}) do
    %{
      id: user_attribution.id,
      user_cookie: user_attribution.user_cookie,
      user_id: user_attribution.user_id,
      attributed_to: user_attribution.attributed_to,
      attribution_start_timestamp: user_attribution.attribution_start_timestamp,
      attribution_window_in_seconds: user_attribution.attribution_window_in_seconds
    }
  end
end
