defmodule WebsFlyerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WebsFlyerWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(WebsFlyerWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(WebsFlyerWeb.ErrorView, :"404")
  end

  def call(conn, {:ok, %{}}) do
    conn
    |> put_status(:ok)
    |> json(%{})
  end
end
