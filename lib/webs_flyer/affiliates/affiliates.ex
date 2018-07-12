defmodule WebsFlyer.Affiliates do 
  alias WebsFlyer.Repo
  import Ecto.Query, only: [from: 2]
  @moduledoc """
  # Affiliates

  The main context for the WebsFlyer service
  """

  import Ecto.Query, warn: false
  alias WebsFlyer.Repo

  alias WebsFlyer.Affiliates.Attribution

  @doc """
  Returns the list of attributions.
  """
  def list_attributions do
    Repo.all(Attribution)
  end

  @doc """
  Gets a single attribution.

  Raises `Ecto.NoResultsError` if the Attribution does not exist.
  """
  def get_attribution!(id), do: Repo.get!(Attribution, id)


  @doc """
  Gets a single attribution by the user_cookie
  """
  def get_attribution(user_cookie) do
    (from a in WebsFlyer.Affiliates.Attribution, 
    where: a.user_cookie == ^user_cookie,
    order_by: [desc: :inserted_at],
    limit: 1) 
    |> Repo.all 
    |> List.first
  end
  @doc ~S"""
  Creates an attribution.

  Required params: `user_cookie`

  """
  def create_attribution(attrs) do
    %Attribution{}
    |> Attribution.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attribution.
  """
  def update_attribution(%Attribution{} = attribution, attrs) do
    attribution
    |> Attribution.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attribution.
  """
  def delete_attribution(%Attribution{} = attribution) do
    Repo.delete(attribution)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attribution changes.
  """
  def change_attribution(%Attribution{} = attribution) do
    Attribution.changeset(attribution, %{})
  end

  alias WebsFlyer.Affiliates.MediaSource

  @doc """
  Returns the list of media_sources.
  """
  def list_media_sources do
    Repo.all(MediaSource)
  end

  @doc """
  Gets a single media_source.

  Raises `Ecto.NoResultsError` if the Media source does not exist.
  """
  def get_media_source!(id), do: Repo.get!(MediaSource, id)

  @doc """
  Gets a single media_source by its aff_name. If more than 1 entries exists,
  the latest one is returned
  """
  def get_media_source_by_name(name) do
    q = from m in MediaSource,
        where: m.aff_name == ^name,
        order_by: [desc: m.inserted_at]
    Repo.all(q)
    |> List.first
  end

  @doc """
  Creates a media_source.
  """
  def create_media_source(attrs \\ %{}) do
    %MediaSource{}
    |> MediaSource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a media_source.
  """
  def update_media_source(%MediaSource{} = media_source, attrs) do
    media_source
    |> MediaSource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MediaSource.
  """
  def delete_media_source(%MediaSource{} = media_source) do
    Repo.delete(media_source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking media_source changes.
  """
  def change_media_source(%MediaSource{} = media_source) do
    MediaSource.changeset(media_source, %{})
  end

  @doc """
  Returns the `media_source`'s `attribution_window_in_seconds` if it exists
  or returns the default 86400 seconds (24 hours) if it doesn't
  """
  def get_attribution_window(source_name) do
    one_month_in_seconds = 30 * 24 * 60 * 60
    case get_media_source_by_name(source_name) do
      nil -> one_month_in_seconds
      media_source ->
        media_source.attribution_window_in_seconds || one_month_in_seconds
    end
  end
end
