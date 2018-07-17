defmodule WebsFlyer.Affiliates.UserAttributions do
  alias WebsFlyer.Repo
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  # Affiliates.UserAttributions

  Context for UserAttributions
  """

  import Ecto.Query, warn: false
  alias WebsFlyer.Repo

  alias WebsFlyer.Affiliates.Schemas.{UserAttribution}  
  require Logger
  @doc """
  Returns the list of user_attributions.

  """
  def list_user_attributions do
    Repo.all(UserAttribution)
  end

  @doc """
  Gets a single user_attribution.

  Raises `Ecto.NoResultsError` if the User attribution does not exist.

  """
  def get_user_attribution!(id), do: Repo.get!(UserAttribution, id)

  @doc """
  Gets a single user_attribution by cookie

  Returns {:error, nil} if the User attribution does no exist.
  """
  def get_by_user_cookie(user_cookie) do
    from(
      ua in UserAttribution,
      where: ua.user_cookie == ^user_cookie,
      order_by: [desc: :updated_at]
    )
    |> Repo.all()
    |> List.first()
  end

  @doc """
  Creates a user_attribution.
  """
  def create_user_attribution(attrs \\ %{}) do
    %UserAttribution{}
    |> UserAttribution.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_attribution.

  """
  def update_user_attribution(%UserAttribution{} = user_attribution, attrs) do
    user_attribution
    |> UserAttribution.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserAttribution.
  """
  def delete_user_attribution(%UserAttribution{} = user_attribution) do
    Repo.delete(user_attribution)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_attribution changes.
  """
  def change_user_attribution(%UserAttribution{} = user_attribution) do
    UserAttribution.changeset(user_attribution, %{})
  end
end
