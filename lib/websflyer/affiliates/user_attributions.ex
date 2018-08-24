defmodule Websflyer.Affiliates.UserAttributions do
  alias Websflyer.Repo
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  # Affiliates.UserAttributions

  Context for UserAttributions
  """

  import Ecto.Query, warn: false
  alias Websflyer.Repo

  alias Websflyer.Affiliates.Schemas.{UserAttribution}
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
  Returns the latest entry if more than 1 exists.
  Returns {:error, nil} if the User attribution does not exist.
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
  Gets a single user_attribution by cookie.
  Returns the latest entry if more than 1 exists.
  Returns {:error, nil} if the user_attribution doesn't exist
  """
  def get_by_user_id(user_id) do
    from(
      ua in UserAttribution,
      where: ua.user_id == ^user_id,
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
  Returns true if a given timestamp is within  `attribution_window_in_seconds` seconds of the
  UserAttribution's `attribution_start_timestamp`
  """
  def within_attribution_window(user_attribution, timestamp) do
    timestamp <
      user_attribution.attribution_start_timestamp +
        user_attribution.attribution_window_in_seconds
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
