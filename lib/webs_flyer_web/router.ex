defmodule WebsFlyerWeb.Router do
  use WebsFlyerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", WebsFlyerWeb.API do
    pipe_through(:api)

    resources("/attributions", AttributionController, as: :api_attribution, except: [:update, :delete])
    resources "/media_sources", MediaSourceController, as: :api_media_source
  end
end
