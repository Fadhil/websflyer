defmodule WebsflyerWeb.HealthController do
  use WebsflyerWeb, :controller

  def index(conn, _params) do
    if core_apps_started?() and core_databases_connected?() do
      send_resp(conn, :ok, "OK")
    else
      send_resp(conn, :internal_server_error, "Internal Server Error")
    end
  end

  defp core_apps_started? do
    core_apps = MapSet.new([
      :websflyer
    ])

    started_apps =
      Application.started_applications()
      |> Enum.map(fn {app, _desc, _vsn} -> app end)
      |> MapSet.new()

    MapSet.subset?(core_apps, started_apps)
  end

  defp core_databases_connected? do
    with :ok <- check_repo_connection(Websflyer.Repo) do
      true
    else
      :error -> false
    end
  end

  defp check_repo_connection(repo) do
    try do
      repo.query("SELECT 1")
      :ok
    rescue
      DBConnection.ConnectionError -> :error
    end
  end
end