defmodule WebsFlyerWeb.Router do
  use WebsFlyerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WebsFlyerWeb do
    pipe_through :api
  end
end
