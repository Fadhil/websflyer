defmodule WebsFlyer.Affiliates.Attributions do
  @moduledoc """
  # Affiliates

  The main context for the WebsFlyer service
  """

  alias WebsFlyer.Repo
  alias WebsFlyer.Affiliates.{MediaSources, UserAttributions}
  alias WebsFlyer.Affiliates.Schemas.{Attribution, UserAttribution}
  import Ecto.Query, only: [from: 2]
  require Logger
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
    from(
      a in WebsFlyer.Affiliates.Schemas.Attribution,
      where: a.user_cookie == ^user_cookie,
      order_by: [desc: :inserted_at],
      limit: 1
    )
    |> Repo.all()
    |> List.first()
  end

  @doc ~S"""
  Creates an attribution.

  Required params: `user_cookie`

  """

  def create_attribution(%{"event" => "click"} = attrs) do
    case basic_attribution(attrs) do
      {:ok, click_attribution} -> 
        {:ok, user_attribution} = UserAttributions.create_user_attribution(%{
          "user_cookie" => click_attribution.user_cookie,
          "user_id" => click_attribution.user_id,
          "attributed_to" => click_attribution.aff_name,
          "attribution_start_timestamp" => get_timestamp(click_attribution.inserted_at),
          "attribution_window_in_seconds" =>
            MediaSources.get_attribution_window(click_attribution.attributed_to)
        })
        {:ok, [click_attribution, user_attribution]}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_attribution(%{"event" => "login"} = attrs) do
    case basic_attribution(attrs) do
      {:ok, login_attribution} -> 
        user_attribution = UserAttributions.get_by_user_cookie(login_attribution.user_cookie)
        case user_attribution do
          nil -> 
            UserAttributions.create_user_attribution(%{
              "user_cookie" => login_attribution.user_cookie,
              "user_id" => login_attribution.user_id,
              "attributed_to" => login_attribution.aff_name,
              "attribution_start_timestamp" => get_timestamp(login_attribution.inserted_at),
              "attribution_window_in_seconds" =>
                MediaSources.get_attribution_window(login_attribution.attributed_to)
            })
          %UserAttribution{} = user_attribution ->
            UserAttributions.update_user_attribution(user_attribution, %{user_id: login_attribution.user_id})
        end
        {:ok, login_attribution}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_attribution(attrs) do
    basic_attribution(attrs)
  end

  def basic_attribution(attrs) do
    attribution =
      %Attribution{}
      |> Attribution.changeset(attrs)
      |> Repo.insert()
  end

  def get_timestamp(naivedatetime) do
    {:ok, datetime} = DateTime.from_naive(naivedatetime, "Etc/UTC")

    datetime
    |> DateTime.to_unix()
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
end
