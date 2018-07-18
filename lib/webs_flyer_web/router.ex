defmodule WebsFlyerWeb.Router do
  use WebsFlyerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug :fetch_session
    plug :put_secure_browser_headers
  end

  scope "/", WebsFlyerWeb do
    pipe_through(:browser)
    get "/track.gif", TrackingController, :track
    get "/tracker.js", TrackingController, :tracker
  end

  scope "/api", WebsFlyerWeb.API do
    pipe_through(:api)

    resources(
      "/attributions",
      AttributionController,
      as: :api_attribution,
      except: [:update, :delete]
    )

    resources("/media_sources", MediaSourceController, as: :api_media_source)
    resources("/user_attributions", UserAttributionController, as: :api_user_attribution)
  end
end
