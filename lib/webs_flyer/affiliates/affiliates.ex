defmodule WebsFlyer.Affiliates do
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

  @doc ~S"""
  Creates an attribution.

  Required params: `user_cookie`

  """
  def create_attribution(attrs \\ %{})
  def create_attribution(%{"event" => "click"} = attrs) do
    %Attribution{}
    |> Attribution.click_changeset(attrs)
    |> Repo.insert()
  end

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
end
