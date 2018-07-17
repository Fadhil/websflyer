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


  describe "click event occurs when a user_attribution for that user_cookie doesn't exists" do
    test "a user_attribution is created with the user_cookie and affiliate name, attribution window and timestamp" do
      assert {:ok, media_source} = MediaSources.create_media_source(TestData.shopback_media_source)
      assert media_source.aff_name == "shopback"
      assert nil == UserAttributions.get_by_user_cookie("random1234usercookie")
      assert {:ok, _click_attribution} = Attributions.create_attribution(TestData.click_shopback_attrs)
      assert %UserAttribution{} = user_attribution = UserAttributions.get_by_user_cookie("random1234usercookie")
      assert user_attribution.attributed_to == "shopback"
      assert not is_nil(user_attribution.attribution_start_timestamp)
    end
  end

  describe "click event occurs when a user_attribution for that user_cookie exists" do
    test "the user_attribution is updated with the new affiliate attribution, attribution window and timestamp" do
      assert {:ok, _sb_media_source} = MediaSources.create_media_source(TestData.shopback_media_source)
      assert {:ok, _cs_media_source} = MediaSources.create_media_source(TestData.carousell_media_source)

      assert {:ok, _click_attribution} = Attributions.create_attribution(TestData.click_shopback_attrs)
      assert %UserAttribution{} = first_user_attribution = UserAttributions.get_by_user_cookie("random1234usercookie")
      assert first_user_attribution.attributed_to == "shopback"
      assert not is_nil(first_user_attribution.attribution_start_timestamp)

      :timer.sleep(500)

      assert {:ok, _click_attribution} = Attributions.create_attribution(TestData.click_carousell_attrs)
      assert %UserAttribution{} = second_user_attribution = UserAttributions.get_by_user_cookie("random1234usercookie")
      assert second_user_attribution.attributed_to == "carousell"
      assert first_user_attribution.id == second_user_attribution.id
      assert second_user_attribution.attribution_start_timestamp > first_user_attribution.attribution_start_timestamp
      
    end
  end

  describe "login event occurs" do
    test "when a user_attribution with the user_cookie exists, the user_attribution is updated with the user_id" do
      assert {:ok, media_source} = MediaSources.create_media_source(TestData.shopback_media_source)
      assert media_source.aff_name == "shopback"

      assert {:ok, _click_attribution} = Attributions.create_attribution(TestData.click_shopback_attrs)
      assert %UserAttribution{} = user_attribution = UserAttributions.get_by_user_cookie("random1234usercookie")
      assert user_attribution.user_id == nil

      assert {:ok, _login_attribution} = Attributions.create_attribution(TestData.login_user_1234_attrs)
      assert %UserAttribution{} = user_attribution = UserAttributions.get_by_user_cookie("random1234usercookie")
      assert user_attribution.user_id == 1234
    end

    test "when a user_attribution with the user_cookie doesn't exist, a new user_attribution is created with the user_cookie and user_id" do
      assert {:ok, media_source} = MediaSources.create_media_source(TestData.shopback_media_source)
      assert media_source.aff_name == "shopback"
      assert nil == UserAttributions.get_by_user_cookie("random1234usercookie")
       
      assert {:ok, _login_attribution} = Attributions.create_attribution(TestData.login_user_1234_attrs)
      assert %UserAttribution{} = user_attribution = UserAttributions.get_by_user_cookie("random1234usercookie")
      assert user_attribution.user_id == 1234
    end
  end
end