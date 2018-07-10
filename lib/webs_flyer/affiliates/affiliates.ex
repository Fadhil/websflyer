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

  ## Examples

      # iex> list_attributions()
      # [%Attribution{}, ...]

  """
  def list_attributions do
    Repo.all(Attribution)
  end

  @doc """
  Gets a single attribution.

  Raises `Ecto.NoResultsError` if the Attribution does not exist.

  ## Examples

      # iex> get_attribution!(123)
      # %Attribution{}
      #
      # iex> get_attribution!(456)
      # ** (Ecto.NoResultsError)

  """
  def get_attribution!(id), do: Repo.get!(Attribution, id)

  @doc ~S"""
  Creates an attribution.

  Required params: `user_cookie`

  """
  def create_attribution(attrs \\ %{}) do
    %Attribution{}
    |> Attribution.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a attribution.

  ## Examples

      # iex> update_attribution(attribution, %{field: new_value})
      # {:ok, %Attribution{}}
      #
      # iex> update_attribution(attribution, %{field: bad_value})
      # {:error, %Ecto.Changeset{}}

  """
  def update_attribution(%Attribution{} = attribution, attrs) do
    attribution
    |> Attribution.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Attribution.

  ## Examples

      # iex> delete_attribution(attribution)
      # {:ok, %Attribution{}}
      #
      # iex> delete_attribution(attribution)
      # {:error, %Ecto.Changeset{}}

  """
  def delete_attribution(%Attribution{} = attribution) do
    Repo.delete(attribution)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking attribution changes.

  ## Examples

      # iex> change_attribution(attribution)
      # %Ecto.Changeset{source: %Attribution{}}

  """
  def change_attribution(%Attribution{} = attribution) do
    Attribution.changeset(attribution, %{})
  end
end
