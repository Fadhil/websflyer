defmodule WebsFlyerWeb.TrackingControllerTest do
  use WebsFlyerWeb.ConnCase

  alias WebsFlyer.Affiliates.Schemas.{Attribution, UserAttribution}
  alias WebsFlyer.Affiliates.{Attributions, MediaSources, UserAttributions}
  alias WebsFlyer.TestData
  alias WebsFlyer.Repo

  setup %{conn: conn} do
    {:ok, _media_source} = MediaSources.create_media_source(TestData.shopback_media_source())
    {:ok, _click_attribution} = Attributions.create_attribution(TestData.click_shopback_attrs())
    {:ok, _login_attribution} = Attributions.create_attribution(TestData.login_user_1234_attrs())

    {:ok, conn: conn}
  end

  describe "tracker" do
    test "when user_attribution with a user_cookie is set, and user_id is sent in params, the user_attribution is updated with the user_id", %{conn: conn} do
      conn = get(conn, tracking_path(conn, :track, url_params: "?utm_source=shopback"))
      assert response(conn, 200)
      last_user_attribution = UserAttribution |> Repo.all |> List.last
      assert %UserAttribution{} = user_attribution = last_user_attribution
      assert not is_nil(user_attribution.user_cookie)

      conn = get(conn, tracking_path(conn, :track, user_id: 3))
      assert response(conn, 200)
      new_last_user_attribution = UserAttribution |> Repo.all |> List.last
      assert new_last_user_attribution.id == last_user_attribution.id
      assert not is_nil(new_last_user_attribution.user_id)

    end
  end
end
