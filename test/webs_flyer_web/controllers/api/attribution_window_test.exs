defmodule WebsFlyerWeb.AttributionWindowTest do
  use WebsFlyerWeb.ConnCase

  alias WebsFlyer.Affiliates
  alias Affiliates.{Attributions, MediaSources, UserAttributions}
  alias WebsFlyer.Repo

  import Ecto.Query, only: [update: 2, from: 2]

  @shopback_media_source %{
    "aff_name" => "shopback",
    "name" => "Shopback People",
    "attribution_window_in_seconds" => 24 * 60 * 60
  }

  @click_shopback_attrs %{
    "event" => "click",
    "url_params" => "?utm_source=shopback&utm_medium=Affiliate",
    "user_cookie" => "randomshopbackusercookie"
  }

  @login_attrs %{
    "event" => "login",
    "user_id" => 3,
    "user_cookie" => "randomshopbackusercookie"
  }

  def fixture(attributes) do
    {:ok, attribution} = Affiliates.create_attribution(attributes)
    attribution
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end


  describe "click event occurs" do
    test "a user_attribution is created with the user_cookie and affiliate name, attribution window and timestamp" do
      {:ok, media_source} = Affiliates.MediaSources.create_media_source(@shopback_media_source)
      {:ok, click_attribution} = Affiliates.Attributions.create_attribution(@click_shopback_attrs)
      # assert Affiliates.UserAttributions.get

    end
    # test "within a clicks attribution window creates a login entry attributed to that affiliate", %{conn: conn} do
    #   {:ok, media_source} = Affiliates.create_media_source(@shopback_media_source)
    #   {:ok, click_attribution} = Affiliates.create_attribution(@click_shopback_attrs)
    #   assert NaiveDateTime.diff(click_attribution.inserted_at , NaiveDateTime.utc_now) < 300
    #   three_hours_ago =  NaiveDateTime.add(NaiveDateTime.utc_now, 3*60*60, :second)
      
    #   {:ok, click_attribution} = Repo.update(Ecto.Changeset.change(click_attribution, inserted_at: three_hours_ago))

    #   assert click_attribution.inserted_at() == three_hours_ago
    #   assert click_attribution.aff_name() == "shopback"

    #   {:ok, login_attribution} = Affiliates.create_attribution(@login_attrs)

    #   assert login_attribution.attributed_to() == "shopback"
    # end
  end
end