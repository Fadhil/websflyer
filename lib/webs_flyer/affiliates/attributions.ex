defmodule WebsFlyer.Affiliates.Attributions do 
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

end