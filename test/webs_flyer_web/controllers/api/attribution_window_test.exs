defmodule WebsFlyerWeb.AttributionWindowTest do
  use WebsFlyerWeb.ConnCase

  alias WebsFlyer.Affiliates
  alias Affiliates.{Attributions, MediaSources, UserAttributions}
  alias Affiliates.Schemas.{UserAttribution}
  alias WebsFlyer.TestData
  # alias WebsFlyer.Repo

  # import Ecto.Query, only: [update: 2, from: 2]



  def fixture(attributes) do
    {:ok, attribution} = Affiliates.create_attribution(attributes)
    attribution
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end


  describe "click event occurs" do
    test "a user_attribution is created with the user_cookie and affiliate name, attribution window and timestamp" do
      assert {:ok, media_source} = MediaSources.create_media_source(TestData.shopback_media_source)
      assert media_source.aff_name == "shopback"
      assert {:ok, click_attribution} = Attributions.create_attribution(TestData.click_shopback_attrs)
      assert %UserAttribution{} = user_attribution = UserAttributions.get_by_user_cookie("randomshopbackusercookie")
      assert user_attribution.attributed_to == "shopback"
      assert not is_nil(user_attribution.attribution_start_timestamp)
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