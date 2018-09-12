defmodule Websflyer.Tasks.Migration do
  import Logger

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  @apps_to_migrate [
    :websflyer
  ]

  def run(_argv) do
    started_at = System.system_time(:seconds)

    info("Starting migrations for #{inspect(@apps_to_migrate)}")

    Enum.each(@apps_to_migrate, fn app ->
      info("Running migrations for #{app}")
      ensure_deps_started()
      ensure_repos_started(app)
      run_migrations_for(app)
      ensure_apps_stopped()
    end)

    ended_at = System.system_time(:seconds)

    info("Migrations completed in #{started_at - ended_at}s")
  end

  defp ensure_deps_started do
    Enum.each(@start_apps, &Application.ensure_all_started/1)
  end

  defp ensure_repos_started(app) do
    app
    |> Application.get_env(:ecto_repos, [])
    |> Enum.each(fn repo -> repo.start_link(pool_size: 1) end)
  end

  defp ensure_apps_stopped do
    :init.stop()
  end

  defp run_migrations_for(app) do
    app
    |> Application.get_env(:ecto_repos, [])
    |> Enum.each(fn repo ->
      migrations_path = priv_path_for(repo, "migrations")
      Ecto.Migrator.run(repo, migrations_path, :up, all: true)
    end)
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end
end